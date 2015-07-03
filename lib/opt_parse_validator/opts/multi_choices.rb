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

    def append_help_messages
      option << 'Available Choices:'

      append_choices_help_messages

      option << "Multiple choices can be supplied, use the '#{separator}' char as a separator"
      option << "If no choice is supplied, '#{value_if_empty}' will be used" if value_if_empty

      append_incomptable_help_messages
    end

    def append_choices_help_messages
      max_spaces = choices.keys.max.size

      choices.each do |key, opt|
        opt_help_messages = opt.help_messages.empty? ? [opt.to_s.humanize] : opt.help_messages

        first_line_prefix  = " #{key} #{' ' * (max_spaces - key.to_s.length)}"
        other_lines_prefix = ' ' * first_line_prefix.size

        opt_help_messages.each_with_index do |message, index|
          prefix = index == 0 ? first_line_prefix : other_lines_prefix
          option << "#{prefix} #{message}"
        end
      end
    end

    def append_incomptable_help_messages
      return if incompatible.empty?

      option << 'Incompatible choices (only one of each group/s can be used):'

      incompatible.each do |a|
        option << " - #{a.map(&:to_s).join(', ')}"
      end
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

      fail OptionParser::InvalidArgument, "Unknown choice: #{item}"
    end

    # @return [ Array<Array<Symbol>> ]
    def incompatible
      [*attrs[:incompatible]]
    end

    # @param [ Hash ] values
    #
    # @return [ Hash ]
    def verify_compatibility(values)
      incompatible.each do |a|
        last_match = ''

        a.each do |key|
          sym = choices[key].to_sym

          next unless values.key?(sym)

          fail OptionParser::InvalidArgument, "Incompatible choices detected: #{last_match}, #{key}" unless last_match.empty?

          last_match = key
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
