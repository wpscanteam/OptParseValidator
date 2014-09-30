module OptParseValidator
  # Base Option
  # This Option should not be called, children should be used.
  class OptBase
    attr_writer :required
    attr_reader :option, :attrs

    # @param [ Array ] option See OptionParser#on
    # @param [ Hash ] attrs
    # @option attrs [ Boolean ] :required
    # @option attrs [ Mixed ] :default The default value to use if the option is not supplied
    # @option attrs [ Boolean ] :to_sym If true, returns the symbol of the validated value
    #
    # @note The :default and :to_sym 'logics' are done in OptParseValidator::OptParser#add_option
    def initialize(option, attrs = {})
      @option = option
      @attrs  = attrs
    end

    # @return [ Boolean ]
    def required?
      @required || attrs[:required]
    end

    # @param [ String ] value
    def validate(value)
      fail 'Empty option value supplied' if value.nil? || value.to_s.empty?
      value
    end

    # Convert the validated value to a symbol if required and possible
    #
    # @param [ Mixed ] value
    #
    # @return [ Mixed ]
    def validated_to_sym(value)
      return value unless attrs[:to_sym] && value.respond_to?(:to_sym)

      value.to_sym
    end

    # @return [ Symbol ]
    def to_sym
      unless @symbol
        long_option = to_long

        fail "Could not find option symbol for #{option}" unless long_option

        @symbol = long_option.gsub(/^--/, '').gsub(/-/, '_').to_sym
      end
      @symbol
    end

    # @return [ String ] The raw long option (e.g: --proxy)
    def to_long
      option.each do |option_attr|
        if option_attr =~ /^--/
          return option_attr.gsub(/ .*$/, '')
                            .gsub(/\[[^\]]+\]/, '')
        end
      end
      nil
    end
  end
end
