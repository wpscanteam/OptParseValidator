# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec/its'
require 'simplecov' # Used filters are defined in /.simplecov
require 'opt_parse_validator'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter

FIXTURES = Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), 'fixtures')))

# See http://betterspecs.org/
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
