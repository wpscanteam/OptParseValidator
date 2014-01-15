# encoding: UTF-8

require 'optparse'

%w{base string integer boolean
   file_path directory_path
}.each do |suffix|
  require 'opts/opt_' + suffix
end

# Validator

class OptParseValidator < OptionParser
  attr_reader :symbols_used, :required_opts

  def initialize(banner = nil, width = 32, indent = ' ' * 4)
    @results       = {}
    @symbols_used  = []
    @required_opts = []

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
        @symbols_used  << opt.symbol
        @required_opts << opt if opt.required?

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
    self.parse!(argv) if @results.empty?

    post_processing

    @results
  end

  # Ensure that all required options are supplied
  # Should be overriden to modify the behavior
  #
  # @return [ Void ]
  def post_processing
    required_opts.each do |opt|
      unless @results.key?(opt.symbol)
        fail "The option #{opt.symbol} is required"
      end
    end
  end
end
