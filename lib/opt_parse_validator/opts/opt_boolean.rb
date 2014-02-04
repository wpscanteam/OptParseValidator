
module OptParseValidator
  # Implementation of the Boolean Option
  class OptBoolean < OptBase
    TRUE_PATTERN  = /^(true|t|yes|y|1)$/i
    FALSE_PATTERN = /^(false|f|no|n|0)$/i

    # @return [ Boolean ]
    def validate(value)
      value = value.to_s

      if value.match(TRUE_PATTERN)
        return true
      elsif value.match(FALSE_PATTERN)
        return false
      else
        fail 'Invalid boolean value, expected true|t|yes|y|1|false|f|no|n|0'
      end
    end
  end
end
