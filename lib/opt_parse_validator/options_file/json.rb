require 'json'

module OptParseValidator
  module OptionsFile
    # Json Implementation
    class JSON < Base
      # @return [ Hash ] a { key: value } hash
      def parse
        ::JSON.parse(File.read(path), symbolize_names: true)
      end
    end
  end
end
