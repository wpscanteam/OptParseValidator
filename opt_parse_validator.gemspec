lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'opt_parse_validator/version'

Gem::Specification.new do |s|
  s.name                  = 'opt_parse_validator'
  s.version               = OptParseValidator::VERSION
  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.0'
  s.authors               = ['WPScanTeam']
  s.email                 = ['contact@wpscan.com']
  s.summary               = 'Ruby OptionParser Validators'
  s.description           = 'Implementation of validators for the ruby OptionParser lib. ' \
                            'Mainly used in the CMSScanner gem to define the cli options available'
  s.homepage              = 'https://github.com/wpscanteam/OptParseValidator'
  s.license               = 'MIT'

  s.files                 = Dir.glob('lib/**/*') + %w[LICENSE README.md]
  s.test_files            = []
  s.require_paths         = ['lib']

  s.add_dependency 'activesupport', '>= 5.2', '< 8.1.0'
  s.add_dependency 'addressable',   '>= 2.5', '< 2.9'
  
  # Fixes warning: ostruct was loaded from the standard library
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.3')
    s.add_dependency('ostruct', '~> 0.6')
  end

  s.add_development_dependency 'bundler',             '>= 1.6'
  s.add_development_dependency 'rake',                '~> 13.0'
  s.add_development_dependency 'rspec',               '~> 3.13.0'
  s.add_development_dependency 'rspec-its',           '~> 2.0.0'
  s.add_development_dependency 'rubocop',             '~> 1.75.6'
  s.add_development_dependency 'rubocop-performance', '~> 1.24.0'
  s.add_development_dependency 'simplecov',           '~> 0.22.0'
  s.add_development_dependency 'simplecov-lcov',      '~> 0.8.0'
end
