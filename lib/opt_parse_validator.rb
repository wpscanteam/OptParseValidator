# encoding: UTF-8

require 'optparse'

%w{base string integer file_path directory_path}.each do |suffix|
  require 'opts/opt_' + suffix
end

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

        self.on(*opt.option) do |arg|
          @results[opt.symbol] = opt.validate(arg)
        end
      else
        raise "The option #{opt.symbol} is already used !"
      end
    else
      raise "The option is not an OptBase, #{opt.class} supplied"
    end
  end

  # @return [ Hash ]
  def results(argv = default_argv)
    self.parse!(argv) if @results.empty?

    required_opts.each do |opt|
      unless @results.has_key?(opt.symbol)
        raise "The option #{opt.symbol} is required"
      end
    end
    @results
  end

end
