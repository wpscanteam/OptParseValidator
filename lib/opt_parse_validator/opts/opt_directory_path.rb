# encoding: utf-8

module OptParseValidator
  # Implemetantion of the DirectoryPath Option
  # The directory must exist
  class OptDirectoryPath < OptBase
    # @param [ String ] value
    #
    # @return [ String ] The path to the directory
    def validate(value)
      fail "The directory #{value} does not exist" unless Dir.exist?(value)
      value
    end
  end
end
