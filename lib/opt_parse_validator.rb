# encoding: utf-8

require 'optparse'

require 'opt_parse_validator/opts'
require 'opt_parse_validator/version'
require 'opt_parse_validator/options_file'

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

    # @param [ OptBase ] options
    #
    # @return [ void ]
    def add(*options)
      options.each { |option| add_option(option) }
    end

    # @param [ OptBase ] opt
    #
    # @return [ void ]
    def add_option(opt)
      if opt.is_a?(OptBase)
        if !@symbols_used.include?(opt.symbol)
          @opts         << opt
          @symbols_used << opt.symbol

          on(*opt.option) do |arg|
            @results[opt.symbol] = opt.validate(arg)
          end
        else
          fail "The option #{opt.symbol} is already used !"
        end
      else
        fail "The option is not an OptBase, #{opt.class} supplied"
      end
    end

    # @return [ Hash ]
    def results(argv = default_argv)
      @results ||= {}

      load_files
      self.parse!(argv)
      post_processing

      @results
    end

    # Ensure that all required options are supplied
    # Should be overriden to modify the behavior
    #
    # @return [ Void ]
    def post_processing
      @opts.each do |opt|
        if opt.required? && !@results.key?(opt.symbol)
          fail "The option #{opt.symbol} is required"
        end
      end
    end
  end
end
