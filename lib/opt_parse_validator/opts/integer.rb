module OptParseValidator
  # Implementation of the Integer Option
  class OptInteger < OptBase
    # @param [ String ] value
    #
    # @return [ Integer ]
    def validate(value)
      fail "#{value} is not an integer" if value.to_i.to_s != value
      value.to_i
    end
  end
end
