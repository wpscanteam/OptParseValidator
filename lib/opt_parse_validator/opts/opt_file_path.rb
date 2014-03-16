# encoding: utf-8

module OptParseValidator
  # Implementation of the FilePath Option
  # The file must exist
  class OptFilePath < OptBase
    # @param [ String ] value
    #
    # @return [ String ] The path to the file
    def validate(value)
      fail "The file #{value} does not exist" unless File.exist?(value)
      value
    end
  end
end
