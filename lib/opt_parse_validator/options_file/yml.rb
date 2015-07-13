require 'yaml'

module OptParseValidator
  module OptionsFile
    # Yaml Implementation
    class YML < Base
      # @return [ Hash ] a { key: value } hash
      def parse
        Hash[YAML.load_file(path).map { |k, v| [k.to_sym, v] }]
      end
    end
  end
end
