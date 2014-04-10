# encoding: utf-8

module OptParseValidator
  # Implementation of the Positive Integer Option
  class OptPositiveInteger < OptInteger
    # @param [ String ] value
    #
    # @return [ Integer ]
    def validate(value)
      i = super(value)
      fail "#{i} is not > 0" unless i > 0
      i
    end
  end
end
