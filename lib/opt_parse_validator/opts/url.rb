# encoding: utf-8

module OptParseValidator
  # Implementation of the URL Option
  class OptURL < OptURI
    # @return [ Array ] The allowed protocols
    def allowed_protocols
      %w(http https)
    end
  end
end
