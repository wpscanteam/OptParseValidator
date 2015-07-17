require 'yaml'

module OptParseValidator
  module OptionsFile
    # Yaml Implementation
    class YML < Base
      # @return [ Hash ] a { key: value } hash
      def parse
        parsed = YAML.load_file(path)

        return {} unless parsed

        Hash[parsed.map { |k, v| [k.to_sym, v] }]
      end
    end
  end
end
