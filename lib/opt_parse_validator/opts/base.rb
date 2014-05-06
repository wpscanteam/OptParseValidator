# encoding: utf-8

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

    # @return [ Symbol ]
    def to_sym
      unless @symbol
        option.each do |option_attr|
          if option_attr =~ /^--/
            # TODO : find a cleaner way to do this
            symbol = option_attr.gsub(/\[[^\]]+\]/, '')
                                .gsub(/^--/, '')
                                .gsub(/-/, '_')
                                .gsub(/ .*$/, '')

            @symbol = symbol.to_sym
            break
          end
        end
        fail "Could not find option symbol for #{option}" unless @symbol
      end
      @symbol
    end
  end
end
