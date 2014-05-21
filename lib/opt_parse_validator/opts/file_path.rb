# encoding: utf-8

module OptParseValidator
  # Implementation of the FilePath Option
  class OptFilePath < OptPath
    # @param [ Array ] option See OptBase#new
    # @param [ Hash ] attrs See OptPath#new
    # :extensions [ Array | String ] The allowed extension(s)
    def initialize(option, attrs = {})
      super(option, attrs)

      @attrs.merge!(file: true)
    end

    def allowed_attrs
      # :extensions is put at the first place
      [:extensions] + super
    end

    def check_extensions(path)
      return if [*attrs[:extensions]].include?(path.extname.delete('.'))

      fail "The extension of '#{path}' is not allowed"
    end
  end
end
