# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'opt_parse_validator/version'

Gem::Specification.new do |s|
  s.name                  = 'opt_parse_validator'
  s.version               = OptParseValidator::VERSION
  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.0.0'
  s.authors               = ['WPScanTeam - Erwan le Rousseau']
  s.email                 = ['erwan.lr@gmail.com']
  s.summary               = 'Testing Gem'
  s.description           = 'Testing Gem ...'
  s.homepage              = 'https://github.com/wpscanteam/OptParseValidator'
  s.license               = 'MIT'

  s.files                 = `git ls-files -z`.split("\x0")
  s.executables           = s.files.grep(/^bin\//) { |f| File.basename(f) }
  s.test_files            = s.files.grep(/^(test|spec|features)\//)
  s.require_paths         = ['lib']

  s.add_dependency 'addressable', '~> 2.3'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec',     '~> 3.1'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'bundler',   '~> 1.6'
  s.add_development_dependency 'rubocop',   '~> 0.26'
  s.add_development_dependency 'simplecov', '~> 0.9'
end
