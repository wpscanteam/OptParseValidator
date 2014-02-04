# encoding: utf-8

Gem::Specification.new do |s|
  s.name = 'opt_parse_validator'
  s.version = '0.0.1'
  s.platform = Gem::Platform::RUBY
  s.authors = ['WPScanTeam - Erwan le Rousseau']
  s.email = ['erwan.lr@gmail.com']
  s.homepage = 'https://github.com/wpscanteam/OptParseValidator'
  s.summary = 'Testing Gem'
  s.description = 'Testing Gem ...'

  #s.required_rubygems_version = ">= 1.3.6"
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
end
