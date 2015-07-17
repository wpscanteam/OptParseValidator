require 'json'

module OptParseValidator
  module OptionsFile
    # Json Implementation
    class JSON < Base
      # @return [ Hash ] a { 'key' => value }
      def parse
        ::JSON.parse(File.read(path))
      end
    end
  end
end
