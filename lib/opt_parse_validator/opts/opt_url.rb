# encoding: utf-8

require 'addressable/uri'

module OptParseValidator
  # Implementation of the URL Option
  class OptURL < OptBase
    # Idea: return the uri instead of the string (url) ?
    # But that would force dev to use Addressable
    #
    # @param [ String ] value
    #
    # @return [ String ]
    def validate(value)
      uri = Addressable::URI.parse(value)

      if !allowed_protocols.include?(uri.scheme)
        raise Addressable::URI::InvalidURIError
      end

      uri.to_s
    end

    protected

    # @return [ Array ] The allowed protocols
    def allowed_protocols
      %w{http https}
    end
  end
end
