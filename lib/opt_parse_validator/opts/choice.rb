module OptParseValidator
  # Implementation of the Choice Option
  class OptChoice < OptBase
    # @param [ Array ] option See OptBase#new
    # @param [ Hash ] attrs
    #   :choices [ Array ] The available choices (mandatory)
    #   :case_sensitive [ Boolean ] Default: false
    def initialize(option, attrs = {})
      fail Error, 'The :choices attribute is mandatory' unless attrs.key?(:choices)
      fail Error, 'The :choices attribute must be an array' unless attrs[:choices].is_a?(Array)

      super(option, attrs)
    end

    # @return [ Void ]
    def append_help_messages
      msg = 'Available choices:'

      choices.each do |choice|
        msg += choice.to_s == default.to_s ? " #{choice} (default)," : " #{choice},"
      end

      option << msg[0..-2]
    end

    # @return [ String ]
    # If :case_sensitive if false (or nil), the downcased value of the choice
    # will be returned
    def validate(value)
      value = value.to_s

      unless attrs[:case_sensitive]
        value.downcase!
        choices.map!(&:downcase)
      end

      fail Error, "'#{value}' is not a valid choice, expected one " \
        "of the followings: #{choices.join(',')}" unless choices.include?(value)

      value
    end
  end
end
