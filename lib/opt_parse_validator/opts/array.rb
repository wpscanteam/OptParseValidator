module OptParseValidator
  # Implementation of the Array Option
  class OptArray < OptBase
    # @param [ String ] value
    #
    # @return [ Array ]
    def validate(value)
      super(value)
      value.split(separator)
    end

    # @return [ String ] The separator used to split the string into an array
    def separator
      attrs[:separator] || ','
    end

    # See OptBase#normalize
    # @param [ Array ] value
    def normalize(values)
      values.each_with_index do |value, index|
        values[index] = super(value)
      end
      values
    end
  end
end