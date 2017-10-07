module OptParseValidator
  # Implementation of the URI Option
  class OptURI < OptBase
    # return [ Void ]
    def append_help_messages
      option << "Allowed Protocols: #{allowed_protocols.join(', ')}" unless allowed_protocols.empty?
      option << "Default Protocol if none provided: #{default_protocol}" if default_protocol

      super
    end

    # @return [ Array<String> ]
    def allowed_protocols
      @allowed_protocols ||= [*attrs[:protocols]]
    end

    # The default protocol (or scheme) to use if none was given
    def default_protocol
      @default_protocol ||= attrs[:default_protocol]
    end

    # @param [ String ] value
    #
    # @return [ String ]
    def validate(value)
      uri = Addressable::URI.parse(value)

      if !uri.scheme && default_protocol
        uri = Addressable::URI.parse("#{default_protocol}://#{value}")
      end

      unless allowed_protocols.empty? || allowed_protocols.include?(uri.scheme)
        # For future refs: will have to check if the uri.scheme exists,
        # otherwise it means that the value was empty
        fail Addressable::URI::InvalidURIError
      end

      uri.to_s
    end
  end
end
