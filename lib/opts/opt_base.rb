# encoding: UTF-8

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
