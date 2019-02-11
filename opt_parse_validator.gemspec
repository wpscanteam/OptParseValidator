lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'opt_parse_validator/version'

Gem::Specification.new do |s|
  s.name                  = 'opt_parse_validator'
  s.version               = OptParseValidator::VERSION
  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3'
  s.authors               = ['WPScanTeam']
  s.email                 = ['team@wpscan.org']
  s.summary               = 'Ruby OptionParser Validators'
  s.description           = 'Implementation of validators for the ruby OptionParser lib. ' \
                            'Mainly used in the CMSScanner gem to define the cli options available'
  s.homepage              = 'https://github.com/wpscanteam/OptParseValidator'
  s.license               = 'MIT'

  s.files                 = Dir.glob('lib/**/*') + %w[LICENSE README.md]
  s.test_files            = []
  s.require_paths         = ['lib']

  s.add_dependency 'activesupport', '>= 4.2', '< 5.3.0'
  s.add_dependency 'addressable',   '~> 2.5.0'

  s.add_development_dependency 'bundler',   '>= 1.6'
  s.add_development_dependency 'coveralls', '~> 0.8.0'
  s.add_development_dependency 'rake',      '~> 12.3'
  s.add_development_dependency 'rspec',     '~> 3.8.0'
  s.add_development_dependency 'rspec-its', '~> 1.2.0'
  s.add_development_dependency 'rubocop',   '~> 0.64.0'
  s.add_development_dependency 'simplecov', '~> 0.16.1'
end
