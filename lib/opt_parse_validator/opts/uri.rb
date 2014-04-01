# encoding: utf-8

module OptParseValidator
  # Implementation of the URI Option
  class OptURI < OptBase
    def allowed_protocols
      @allowed_protocols ||= [*attrs[:protocols]]
    end

    # @param [ String ] value
    #
    # @return [ String ]
    def validate(value)
      uri       = Addressable::URI.parse(value)
      protocols = allowed_protocols

      unless protocols.empty? || protocols.include?(uri.scheme)
        # For future refs: will have to check if the uri.scheme exists,
        # otherwise it means that the value was empty
        fail Addressable::URI::InvalidURIError
      end

      uri.to_s
    end
  end
end
