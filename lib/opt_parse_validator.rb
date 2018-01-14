# Gems
require 'addressable/uri'
require 'active_support/inflector'
# Standard Libs
require 'optparse'
require 'pathname'
# Custom Libs
require 'opt_parse_validator/errors'
require 'opt_parse_validator/hacks'
require 'opt_parse_validator/opts'
require 'opt_parse_validator/version'
require 'opt_parse_validator/options_files'

# Gem namespace
module OptParseValidator
  # Validator
  class OptParser < OptionParser
    attr_reader :symbols_used, :opts

    def initialize(banner = nil, width = 32, indent = ' ' * 4)
      @results      = {}
      @symbols_used = []
      @opts         = []

      super(banner, width, indent)
    end

    # @return [ OptParseValidator::OptionsFiles ]
    def options_files
      @options_files ||= OptionsFiles.new
    end

    # @param [ Array<OptBase> ] options
    #
    # @return [ void ]
    def add(*options)
      options.each do |option|
        check_option(option)

        @opts << option
        @symbols_used << option.to_sym

        # Set the default option value if it exists
        # The default value is not validated as it is provided by devs
        # and should be set to the correct format/value directly
        @results[option.to_sym] = option.default unless option.default.nil?

        register_callback(option)
      end
    end

    # @return [ Hash ]
    def results(argv = default_argv)
      load_options_files
      parse!(argv)
      post_processing

      @results
    rescue StandardError => e
      # Raise it as an OptParseValidator::Error if not already one
      raise e.is_a?(Error) ? e.class : Error, e.message
    end

    protected

    # Ensures the opt given is valid
    #
    # @param [ OptBase ] opt
    #
    # @return [ void ]
    def check_option(opt)
      raise Error, "The option is not an OptBase, #{opt.class} supplied" unless opt.is_a?(OptBase)
      raise Error, "The option #{opt.to_sym} is already used !" if @symbols_used.include?(opt.to_sym)
    end

    # @param [ OptBase ] opt
    #
    # @return [ void ]
    def register_callback(opt)
      on(*opt.option) do |arg|
        begin
          if opt.alias?
            parse!(opt.alias_for.split(' '))
          else
            @results[opt.to_sym] = opt.normalize(opt.validate(arg))
          end
        rescue StandardError => e
          # Adds the long option name to the message
          # And raises it as an OptParseValidator::Error if not already one
          # e.g --proxy Invalid Scheme format.
          raise e.is_a?(Error) ? e.class : Error, "#{opt.to_long} #{e}"
        end
      end
    end

    # @return [ Void ]
    def load_options_files
      files_data = options_files.parse

      @opts.each do |opt|
        next unless files_data.key?(opt.to_sym)

        @results[opt.to_sym] = opt.normalize(opt.validate(files_data[opt.to_sym].to_s))
      end
    end

    # Ensure that all required options are supplied
    # Should be overriden to modify the behavior
    #
    # @return [ Void ]
    def post_processing
      @opts.each do |opt|
        if opt.required?
          raise NoRequiredOption, "The option #{opt} is required" unless @results.key?(opt.to_sym)
        end

        next if opt.required_unless.empty?
        next if @results.key?(opt.to_sym)

        fail_msg = "One of the following options is required: #{opt}, #{opt.required_unless.join(', ')}"

        raise NoRequiredOption, fail_msg unless opt.required_unless.any? do |sym|
          @results.key?(sym)
        end
      end
    end
  end
end
