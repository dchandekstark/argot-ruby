lib = File.expand_path('../lib/', __FILE__)

$:.unshift(lib) unless $:.include?(lib)

require 'argot'

Gem::Specification.new do |s|
    s.name          = 'argot'
    s.version       = Argot::VERSION
    s.date          = '2016-10-10'
    s.summary       = 'Tools for shared ingest infrastructure'
    s.description   = 'see summary?'
    s.authors       = ['Adam Constabaris']
    s.files         = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
    s.require_path  = 'lib'
    s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }


    s.add_runtime_dependency "yajl-ruby", [">=1.2.1"]
    s.add_runtime_dependency "nokogiri", [">=0"]
    s.add_runtime_dependency "traject", [">=0"]
    s.add_runtime_dependency "lisbn", [">=0"]

end
