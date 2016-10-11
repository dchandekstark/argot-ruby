require 'nokogiri'
require 'lisbn'

##
# Implements a handler that extracts ICE Data from Syndetics in a handy format from USMARC records.
# [rdoc-ref:Argot::XML::EventHandler]
module Argot::XML
    class ICEExtractor
        ## 
        # Normalizes an input candidate ISBN  (upcase, strip irrelevant characters)
        # and returns two values, boolean indicating validity and the normalized
        # value
        def good_isbn?(value)
            v = value.upcase().gsub(/[^0-9X]/, '')
            [ Lisbn.new(v).valid?, v ]
        end

        def marc005todate(marc_value)
            y, m, d, hr, min,sec = marc_value.unpack("a4a2a2a2a2a2").map { |x| x.to_i }
            return DateTime.new(y,m,d,hr,min,sec)
        end

        ##
        # extracts a record hash from a USMARC record
        # *+rec+ a Nokogiri::XML::Element USMARC element
        # 
        # The returned hash has the following structure:
        # * +:id+ the ID assigned to the record by Sydnetics 
        # * +:update_date_time+ the time the record was last updated, according to the 005
        # * +:isbn+ an array of ISBNs
        # * +:title+ the title from the 245
        # * +chapters+ : an array of hashes describing the chapters (TOC)
        # ** +:authors+ - an array of authors for the chapter (if present)0
        # ** +:title+ - the chapter title (if present)
        def call(el) 
            record_id = el.xpath("VarFlds/VarCFlds/Fld001/text()")[0].text
            update_date_time = marc005todate(el.xpath("VarFlds/VarCFlds/Fld005/text()")[0].text)

            dfld = el.xpath("VarFlds/VarDFlds[1]")[0]
            ssifld = dfld.xpath("SSIFlds[1]")[0]
            isbns = dfld.xpath("NumbCode/Fld020/a/text()")
                .map    { |i| good_isbn?(i.text) }
                .select { |good,v| good }
                .map    { |t,v| v }

            title = dfld.xpath("Titles/Fld245/*[self::a or self::b][1]/text()")[0].text
            chapters = ssifld.xpath("Fld970[@I1 != '0']").map { |field|
                d = {}
                authors = field.xpath("e|f/text()")
                titles = field.xpath("t/text()")
                d[:authors] = authors unless authors.empty?
                if not titles.nil? and titles.length > 0 and not titles[0].text.empty?
                    d[:title] = titles[0].text
                end
                d
            }
            .select { |d| d }
            rec = { 
                :id => record_id,
                :update_date_time => update_date_time,
                :isbn => isbns,
                :title => title,
                :chapters => chapters 
            }
            rec
        end

    end
end