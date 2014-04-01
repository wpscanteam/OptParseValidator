# encoding: utf-8

module OptParseValidator
  # Implemetantion of the DirectoryPath Option
  class OptDirectoryPath < OptPath
    def initialize(option, attrs = {})
      super(option, attrs)

      @attrs.merge!(directory: true)
    end
  end
end
