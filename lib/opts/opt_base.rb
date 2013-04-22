# encoding: UTF-8

class OptBase

  attr_accessor :required
  attr_reader   :option, :symbol

  # @param [ Array ] option See OptionParser#on
  # @param [ Hash ] attrs
  # @option attrs [ Boolean ] :required
  def initialize(option, attrs = {})
    @option   = option
    @required = attrs[:required] || false
    @symbol   = OptBase.find_symbol(option)
  end

  # @return [ Boolean ]
  def required?
    required
  end

  # @param [ String ] value
  def validate(value)
    raise 'Empty option value supplied' if value.nil? || value.to_s.empty?
    value
  end

  protected

  # @param [ Array ] option See OptionParser#on
  #
  # @return [ Symbol ]
  def self.find_symbol(option)
    option.each do |option_attr|
      if option_attr =~ /^--/
        symbol = option_attr.gsub(/^--/, '').gsub(/-/, '_').gsub(/ .*$/, '')

        return symbol.to_sym
      end
    end

    raise "Could not find the option symbol for #{option}"
  end

end
