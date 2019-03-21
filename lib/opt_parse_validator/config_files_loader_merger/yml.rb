# frozen_string_literal: true

require 'yaml'

module OptParseValidator
  class ConfigFilesLoaderMerger < Array
    module ConfigFile
      # Yaml Implementation
      class YML < Base
        # @params [ Hash ] opts
        # @option opts [ Array ] :yaml_arguments See https://ruby-doc.org/stdlib-2.3.1/libdoc/psych/rdoc/Psych.html#method-c-safe_load
        #
        # @return [ Hash ] a { 'key' => value } hash
        def parse(opts = {})
          YAML.safe_load(File.read(path), *opts[:yaml_arguments]) || {}
        end
      end
    end
  end
end
