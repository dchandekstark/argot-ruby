lib = File.expand_path('../lib/', __FILE__)

$:.unshift(lib) unless $:.include?(lib)

require 'argot/meta'

is_java = RUBY_PLATFORM =~ /java/

Gem::Specification.new do |s|
    s.name          = 'argot'
    s.version       = Argot::VERSION
    s.date          = '2016-10-10'
    s.summary       = 'Tools for shared ingest infrastructure'
    s.description   = 'see summary?'
    s.authors       = ['Adam Constabaris','Luke Aeschleman']
    s.files         = Dir.glob("{bin,lib}/**/*.{rb,yml}") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
    s.require_path  = 'lib'
    s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

    s.add_runtime_dependency 'rubyzip', [ '~> 1.2' ]

    # pick our JSON library to install depending on the platform
    if is_java
        s.platform = 'java'
        s.add_runtime_dependency 'jar-dependencies', [ '~> 0.3', '>=0.3.9']
        s.requirements << "jar org.noggit:noggit, 0.7"
    else
        s.add_runtime_dependency 'yajl-ruby', ['~> 1.2', ">=1.2.1"]
    end

    # nokogiri  1.7 requires Ruby 2.1.0
    nokogiri_versions = [ '~> 1.6', ' >= 1.6.8' ]
    nokogiri_versions << '< 1.7' if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.1.0")
    s.add_runtime_dependency 'nokogiri', nokogiri_versions

    s.add_runtime_dependency 'traject', [ '~> 2.0' ]
    s.add_runtime_dependency 'lisbn', ['~> 0.2' ]
    s.add_runtime_dependency 'thor', ['~> 0.19.4']
    s.add_runtime_dependency 'rsolr', [ '~> 1.1', '>=1.1.2']

    # system rubies may be installed wihtout minitest
    s.add_development_dependency 'minitest', '~> 5.0'

end
