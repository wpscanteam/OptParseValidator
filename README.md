OptParseValidator
=================

[![Gem Version](https://badge.fury.io/rb/opt_parse_validator.svg)](https://badge.fury.io/rb/opt_parse_validator)
[![Build Status](https://img.shields.io/travis/wpscanteam/OptParseValidator.svg)](https://travis-ci.org/wpscanteam/OptParseValidator)
[![Coverage Status](https://img.shields.io/coveralls/wpscanteam/OptParseValidator.svg)](https://coveralls.io/r/wpscanteam/OptParseValidator?branch=master)
[![Code Climate](https://img.shields.io/codeclimate/github/wpscanteam/OptParseValidator.svg)](https://codeclimate.com/github/wpscanteam/OptParseValidator)
[![Dependency Status](https://img.shields.io/gemnasium/wpscanteam/OptParseValidator.svg)](https://gemnasium.com/wpscanteam/OptParseValidator)


### Available Validators & associated attributes:
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
