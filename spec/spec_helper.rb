$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

FIXTURES = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))

require 'simplecov'
require 'opt_parse_validator'
