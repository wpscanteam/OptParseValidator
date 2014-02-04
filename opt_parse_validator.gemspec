# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'opt_parse_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "opt_parse_validator"
  spec.version       = OptParseValidator::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['WPScanTeam - Erwan le Rousseau']
  spec.email         = ["erwan.lr@gmail.com"]
  spec.summary       = %q{Testing Gem}
  spec.description   = %q{Testing Gem ...}
  spec.homepage      = "https://github.com/wpscanteam/OptParseValidator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
