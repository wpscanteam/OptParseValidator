module OptParseValidator
  # Implementation of the Scope Option
  class OptScope < OptArray
    # @param [ String ] value
    #
    # @return [ Array<PublicSuffix::Domain> ]
    def validate(value)
      super(value).map { |s| PublicSuffix.parse(s) }
    end
  end
end
