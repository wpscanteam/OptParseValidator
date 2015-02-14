module OptParseValidator
  # Implementation of the Integer Range Option
  class OptIntegerRange < OptBase
    # @param [ String ] value
    #
    # @return [ Range ]
    def validate(value)
      a = super(value).split(separator)

      fail "Incorrect number of ranges found: #{a.size}, should be 2" unless a.size == 2
      fail 'Argument is not a valid integer range' unless a.first.to_i.to_s == a.first && a.last.to_i.to_s == a.last

      (a.first.to_i..a.last.to_i)
    end

    # @return [ String ]
    def separator
      attrs[:separator] || '-'
    end
  end
end
