# encoding: UTF-8

require 'optparse'

class CustomOptionParser < OptionParser

  attr_reader :symbols_used

  def initialize(banner = nil, width = 32, indent = ' ' * 4)
    @results = {}
    @symbols_used = []
    super(banner, width, indent)
  end


  # param Array(Array) or Array options
  def add(options)
    if options.is_a?(Array)
      if options[0].is_a?(Array)
        options.each do |option|
          add_option(option)
        end
      else
        add_option(options)
      end
    else
      raise "Options must be at least an Array, or an Array(Array). #{options.class} supplied"
    end
  end

  # param Array option
  def add_option(option)
    if option.is_a?(Array)
      option_symbol = CustomOptionParser::option_to_symbol(option)

      if !@symbols_used.include?(option_symbol)
        @symbols_used << option_symbol

        self.on(*option) do |arg|
          @results[option_symbol] = arg
        end
      else
        raise "The option #{option_symbol} is already used !"
      end
    else
      raise "The option must be an array, #{option.class} supplied : '#{option}'"
    end
  end

  def add_opt(opt)
    if opt.is_a?(OptBase)
      option     = opt.option
      opt_symbol = CustomOptionParser::option_to_symbol(option)

      if !@symbols_used.include?(opt_symbol)
        @symbols_used << opt_symbol

        self.on(*option) do |arg|
          @results[opt_symbol] = opt.validate(arg)
        end
      else
        raise "The option #{option_symbol} is already used !"
      end
    end
  end

  # return Hash
  def results(argv = default_argv)
    self.parse!(argv) if @results.empty?

    @results
  end

  protected
  # param Array option
  def self.option_to_symbol(option)
    option_name = nil

    option.each do |option_attr|
      if option_attr =~ /^--/
        option_name = option_attr
        break
      end
    end

    if option_name
      option_name = option_name.gsub(/^--/, '').gsub(/-/, '_').gsub(/ .*$/, '')
      :"#{option_name}"
    else
      raise "Could not find the option name for #{option}"
    end
  end
end

class OptBase

  attr_accessor :required
  attr_reader   :option

  # @param [ Array ] option See OptionParser#on
  # @param [ Hash ] attrs
  # @option attrs [ Boolean ] :require
  def initialize(option, attrs = {})
    @option = option
    required = attrs[:required] || false
  end

  # @return [ Boolean ]
  def required?
    required
  end

  # @param [ String ] value
  def validate(value)
    if value.nil? || value.to_s.empty?
      raise 'Empty option value supplied'
    end
    value
  end
end

class OptInteger < OptBase
  def validate(value)
    if value.to_i.to_s != value
      raise "#{value} is not an integer"
    end
    value.to_i
  end
end

begin

  option_parser = CustomOptionParser.new

  option_parser.add_opt(
    OptBase.new(['-u', '--url URL', 'the target URL']),
  )
  option_parser.add_opt(
    OptInteger.new(['-t', '--threads MAX_THREADS'])
  )

  p option_parser.results

rescue => e
  puts e.message
  puts
  puts option_parser
end
