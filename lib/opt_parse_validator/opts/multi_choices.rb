module OptParseValidator
  # Implementation of the MultiChoices Option
  class OptMultiChoices < OptArray
    # @param [ Array ] option See OptBase#new
    # @param [ Hash ] attrs
    # @option attrs [ Hash ] :choices
    # @option attrs [ Array<Array> ] :incompatible
    # @options attrs [ String ] :separator See OptArray#new
    def initialize(option, attrs = {})
      fail 'The :choices attribute is mandatory' unless attrs.key?(:choices)
      fail 'The :choices attribute must be a hash' unless attrs[:choices].is_a?(Hash)

      super(option, attrs)
    end

    # @param [ String ] value
    #
    # @return [ Hash ]
    def validate(value)
      results = {}

      super(value).each do |item|
        opt = choices[item.to_sym]

        if opt
          opt_value = opt.value_if_empty.nil? ? true : opt.value_if_empty
        else
          opt, opt_value = value_from_pattern(item)
        end

        results[opt.to_sym] = opt.normalize(opt.validate(opt_value))
      end

      verify_compatibility(results)
    end

    # @return [ Array ]
    def value_from_pattern(item)
      choices.each do |key, opt|
        next unless item.match(/\A#{key.to_s}(.*)\z/)

        return [opt, Regexp.last_match[1]]
      end

      fail "Unknown choice: #{item}"
    end

    # @param [ Hash ] values
    #
    # @return [ Hash ]
    def verify_compatibility(values)
      [*attrs[:incompatible]].each do |a|
        last_match = ''

        a.each do |sym|
          next unless values.key?(sym)

          if last_match.empty?
            last_match = sym
          else
            fail "Incompatible choices detected: #{last_match}, #{sym}"
          end
        end
      end
      values
    end

    # No normalization
    def normalize(value)
      value
    end
  end
end
