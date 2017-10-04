OptParseValidator
=================

[![Gem Version](https://badge.fury.io/rb/opt_parse_validator.svg)](https://badge.fury.io/rb/opt_parse_validator)
[![Build Status](https://img.shields.io/travis/wpscanteam/OptParseValidator.svg)](https://travis-ci.org/wpscanteam/OptParseValidator)
[![Coverage Status](https://img.shields.io/coveralls/wpscanteam/OptParseValidator.svg)](https://coveralls.io/r/wpscanteam/OptParseValidator?branch=master)
[![Code Climate](https://img.shields.io/codeclimate/github/wpscanteam/OptParseValidator.svg)](https://codeclimate.com/github/wpscanteam/OptParseValidator)
[![Dependency Status](https://img.shields.io/gemnasium/wpscanteam/OptParseValidator.svg)](https://gemnasium.com/wpscanteam/OptParseValidator)


### Installation

```gem install opt_parse_validator```

### Usage Example

```ruby
require 'opt_parse_validator'

# For contructor options, such as setting a banner, the summary width and indent,
# see http://ruby-doc.org/stdlib-2.4.2/libdoc/optparse/rdoc/OptionParser.html#method-c-new
parser = OptParseValidator::OptParser.new

parser.add(
  OptParseValidator::OptBoolean.new(['--test', '-t', 'Option Helper Message']),
  OptParseValidator::OptFilePath.new(['-o', '--output FILE', 'Output to FILE'], writable: true, exists: false)
)

p parser.results
```

For more option examples, see
 - https://github.com/wpscanteam/CMSScanner/blob/master/app/controllers/core/cli_options.rb
 - https://github.com/wpscanteam/wpscan-v3/blob/master/app/controllers/enumeration/cli_options.rb

Please Feel free to send Pull Requests to improve this Readme

### Available Validators & Associated Attributes:
- Array
  - :separator (default: ',')
- Boolean
- Choice
  - :choices (mandatory)
  - :case_sensitive
- Credentials
- Directory Path
  - :exists
  - :executable
  - :readable
  - :writable
- File Path
  - :exists
  - :executable
  - :readable
  - :writable
- Headers
- Integer
- IntegerRange
  - separator (default: '-')
- MultiChoices
  - choices (mandatory)
  - separator (default: ',')
  - value_if_empty
  - incompatible
- Positive Integer
- Path
  - :file
  - :directory
  - :exists
  - :executable
  - :readable
  - :writable
- Proxy
  - :protocols
  - :default_protocol
- Regexp:
  - :options (See http://ruby-doc.org/core-2.2.1/Regexp.html#method-c-new)
- String
- URI
  - :protocols
  - :default_protocol
- URL
  - :default_protocol
