# frozen_string_literal: true

require 'yaml'

module OptParseValidator
  class ConfigFilesLoaderMerger < Array
    module ConfigFile
      # Yaml Implementation
      class YML < Base
        # @params [ Hash ] opts
        # @option opts [ Hash ] :yaml_options See https://ruby-doc.org/stdlib-2.6.3/libdoc/psych/rdoc/Psych.html#method-c-safe_load
        #
        # @return [ Hash ] a { 'key' => value } hash
        def parse(opts = {})
          yaml_safe_load(path, opts[:yaml_options] || {})
        end
      end
    end
  end
end
