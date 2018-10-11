OptParseValidator
=================

[![Gem Version](https://badge.fury.io/rb/opt_parse_validator.svg)](https://badge.fury.io/rb/opt_parse_validator)
[![Build Status](https://img.shields.io/travis/wpscanteam/OptParseValidator.svg)](https://travis-ci.org/wpscanteam/OptParseValidator)
[![Coverage Status](https://img.shields.io/coveralls/wpscanteam/OptParseValidator.svg)](https://coveralls.io/r/wpscanteam/OptParseValidator?branch=master)
[![Code Climate](https://api.codeclimate.com/v1/badges/56f0307bbbda6d41b99a/maintainability)](https://codeclimate.com/github/wpscanteam/OptParseValidator/maintainability)


### Installation

```gem install opt_parse_validator```

### Usage Example

```ruby
# test.rb

require 'opt_parse_validator'

begin
  # For constructor options, such as setting a banner, the summary width and indent,
  # see http://ruby-doc.org/stdlib-2.4.2/libdoc/optparse/rdoc/OptionParser.html#method-c-new
  parsed_cli_options = OptParseValidator::OptParser.new.add(
    OptParseValidator::OptString.new(['-m', '--mandatory PARAM', 'A Mandatory CLI option'], required: true),
    OptParseValidator::OptBoolean.new(['--test', '-t', 'Option Helper Message']),
    OptParseValidator::OptFilePath.new(['-o', '--output FILE', 'Output to FILE'], writable: true, exists: false),
    OptParseValidator::OptAlias.new(['--alias', '-a'], alias_for: '--test -o file.txt')
  ).results

  p parsed_cli_options
rescue OptParseValidator::Error => e
  puts 'Parsing Error: ' + e.message
end
```

Then have a play with
```ruby test.rb -h```
```ruby test.rb -m hh -t```
```ruby test.rb -t```

It is worth to note that when aliases are used, it is recommended to provide them first in the CLI. Otherwise, they might override user-suplied cli options. For example, using the options above, ```ruby test.rb -m aa -o override.txt --alias``` won't have the desired effect (to have --output as override.txt), but ```ruby test.rb --alias -m aa -o override.txt``` will.

For more option examples, see
 - https://github.com/wpscanteam/CMSScanner/blob/master/app/controllers/core/cli_options.rb
 - https://github.com/wpscanteam/wpscan/blob/master/app/controllers/enumeration/cli_options.rb

Please feel free to send Pull Requests to improve this Readme

### Global Attributes

Some attributes are available for all Validators:
- :required (whether or not the associated cli option is required/mandatory - [example](https://github.com/wpscanteam/CMSScanner/blob/master/app/controllers/core/cli_options.rb#L9)).
- :required_unless (like the above, except if the option/s given in this parameter are called in the CLI - [example](https://github.com/wpscanteam/wpscan/blob/master/app/controllers/core.rb#L7), can be a single symbol or array of symbols)
- :default (Default value to use if the option is not supplied, the correct format has to be used as it won't go through the validation and normalization processes)
- :value_if_empty (Value to use if no argument has been supplied for the related option)

### Available Validators & Associated Attributes:
- Alias:
  - :alias_for (mandatory)
- Array
  - :separator (default: ',')
- Boolean
- Choice
  - :choices (mandatory)
  - :case_sensitive
- Credentials
- Directory Path
  - :create
  - :exists
  - :executable
  - :readable
  - :writable
- File Path
  - :create
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
  - incompatible
- Positive Integer
- Path
  - :create
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
- SmartList
  - separator (default: ',')
- String
- URI
  - :protocols
  - :default_protocol
- URL
  - :default_protocol
