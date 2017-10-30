require 'yaml'

module OptParseValidator
  module OptionsFile
    # Yaml Implementation
    class YML < Base
      # @return [ Hash ] a { 'key' => value } hash
      def parse
        YAML.safe_load(File.read(path)) || {}
      end
    end
  end
end
