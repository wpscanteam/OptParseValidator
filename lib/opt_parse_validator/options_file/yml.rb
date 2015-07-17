require 'yaml'

module OptParseValidator
  module OptionsFile
    # Yaml Implementation
    class YML < Base
      # @return [ Hash ] a { 'key' => value } hash
      def parse
        YAML.load_file(path) || {}
      end
    end
  end
end
