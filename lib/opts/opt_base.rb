# encoding: UTF-8

# Base Option
# This Option should not be called, children should be used.

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
    fail 'Empty option value supplied' if value.nil? || value.to_s.empty?
    value
  end

  protected

  # @param [ Array ] option See OptionParser#on
  #
  # @return [ Symbol ]
  def self.find_symbol(option)
    option.each do |option_attr|
      if option_attr =~ /^--/
        # TODO : find a cleaner way to do this
        symbol = option_attr.gsub(/\[[^\]]+\]/, '')
                            .gsub(/^--/, '')
                            .gsub(/-/, '_')
                            .gsub(/ .*$/, '')

        return symbol.to_sym
      end
    end

    fail "Could not find option symbol for #{option}"
  end
end
