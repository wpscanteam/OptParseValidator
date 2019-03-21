# frozen_string_literal: true

module OptParseValidator
  # Implemetantion of the DirectoryPath Option
  class OptDirectoryPath < OptPath
    def initialize(option, attrs = {})
      super(option, attrs)

      @attrs.merge!(directory: true)
    end

    # @param [ Pathname ] path
    def check_create(path)
      FileUtils.mkdir_p(path.to_s) unless Dir.exist?(path.to_s)
    end
  end
end
