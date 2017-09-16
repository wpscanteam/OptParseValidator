module OptParseValidator
  # Implementation of the Headers Option
  class OptHeaders < OptBase
    # @return [ Void ]
    def append_help_messages
      option << "Separator to use between the headers: '; '"
    end

    # @param [ String ] value
    #
    # @return [ Hash ] The parsed headers in a hash, with { 'key' => 'value' } format
    def validate(value)
      values = super(value).chomp(';').split('; ')

      headers = {}

      values.each do |header|
        fail Error, "Malformed header: '#{header}'" unless header.index(':')

        val = header.split(':', 2)

        headers[val[0].strip] = val[1].strip
      end

      headers
    end
  end
end
