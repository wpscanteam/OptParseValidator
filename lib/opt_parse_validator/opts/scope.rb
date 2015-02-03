module OptParseValidator
  # Implementation of the Scope Option
  class OptScope < OptArray
    # @param [ String ] value
    #
    # @return [ Array<PublicSuffix::Domain, String> ]
    def validate(value)
      values = super(value)

      values.each_with_index do |v, i|
        values[i] = PublicSuffix.parse(v) if PublicSuffix.valid?(v)
      end
    end
  end
end
