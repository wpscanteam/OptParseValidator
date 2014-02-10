# encoding: utf-8

require 'addressable/uri'

module OptParseValidator
  # Implementation of the URI Option
  class OptURI < OptBase
    attr_reader :allowed_protocols

    # @see OptBase#new
    def initialize(option, attrs = {})
      self.allowed_protocols = attrs[:protocols] || []
      super(option, attrs)
    end

    # @param [ Array ] protocols
    #
    # @return [ Void ]
    def allowed_protocols=(protocols)
      if protocols.is_a?(Array)
        @allowed_protocols = protocols
      else
        fail "Protocols must be an Array, #{protocols.class} given"
      end
    end

    # Idea: return the uri instead of the string (url) ?
    # But that would force devs to use Addressable
    #
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
