module OptParseValidator
  # Implementation of the Choice Option
  class OptChoice < OptBase
    # @param [ Array ] option See OptBase#new
    # @param [ Hash ] attrs
    #   :choices [ Array ] The available choices (mandatory)
    #   :case_sensitive [ Boolean ] Default: false
    def initialize(option, attrs = {})
      fail 'The :choices attribute is mandatory' unless attrs.key?(:choices)
      fail 'The :choices attribute must be an array' unless attrs[:choices].is_a?(Array)

      super(option, attrs)
    end

    # @return [ String ]
    # If :case_sensitive if false (or nil), the downcased value of the choice
    # will be returned
    def validate(value)
      value   = value.to_s
      choices = attrs[:choices]

      unless attrs[:case_sensitive]
        value.downcase!
        choices.map!(&:downcase)
      end

      fail "'#{value}' is not a valid choice, expected one " \
           "of the followings: #{choices.join(',')}" unless choices.include?(value)

      value
    end
  end
end
