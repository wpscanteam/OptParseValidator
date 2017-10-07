module OptParseValidator
  # Implementation of the SmartList Option
  # Such option allow users to supply a list like
  # - name1
  # - name1,name2,name3
  # - /tmp/names.txt
  class OptSmartList < OptArray
    # @return [ Void ]
    def append_help_messages
      # calls the parent methods to have potential related messages
      # but removes the last help message from OptArray about the separator
      # as useless here
      super.pop

      option << "Examples: 'a1', '#{%w[a1 a2 a3].join(separator)}', '/tmp/a.txt'"
    end

    # @param [ String ] value
    #
    # @return [ Array<String> ]
    def validate(value)
      # Might be a better way to do this especially with a big file
      File.open(value).map(&:chomp)
    rescue Errno::ENOENT
      super(value)
    end
  end
end
