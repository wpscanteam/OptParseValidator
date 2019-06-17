# frozen_string_literal: true

require_relative 'config_files_loader_merger/base'
require_relative 'config_files_loader_merger/json'
require_relative 'config_files_loader_merger/yml'

# :nocov:
# @param [ String ] path The path of the file to load
# @param [ Hash ] opts See https://ruby-doc.org/stdlib-2.6.3/libdoc/psych/rdoc/Psych.html#method-c-safe_load
def yaml_safe_load(path, opts = {})
  if Gem::Version.new(Psych::VERSION) >= Gem::Version.new('3.1.0.pre1') # Ruby 2.6
    YAML.safe_load(File.read(path), opts) || {}
  else
    YAML.safe_load(File.read(path), opts[:permitted_classes] || [], opts[:permitted_symbols] || [], opts[:aliases]) || {}
  end
end
# :nocov:

module OptParseValidator
  # Options Files container
  class ConfigFilesLoaderMerger < Array
    # @return [ Array<String> ] The downcased supported extensions list
    def self.supported_extensions
      extensions = ConfigFile.constants.select do |const|
        name = ConfigFile.const_get(const)
        name.is_a?(Class) && name != ConfigFile::Base
      end

      extensions.map { |sym| sym.to_s.downcase }
    end

    # @param [ String ] file_path
    #
    # @return [ Self ]
    def <<(file_path)
      return self unless File.exist?(file_path)

      ext = File.extname(file_path).delete('.')

      raise Error, "The option file's extension '#{ext}' is not supported" unless self.class.supported_extensions.include?(ext)

      super(ConfigFile.const_get(ext.upcase).new(file_path))
    end

    # @params [ Hash ] opts
    # @option opts [ Boolean ] :symbolize_keys Whether or not to symbolize keys in the returned hash
    # @option opts [ Array ] :yaml_arguments See https://ruby-doc.org/stdlib-2.3.1/libdoc/psych/rdoc/Psych.html#method-c-safe_load
    #
    # @return [ Hash ]
    def parse(opts = {})
      result = {}

      each { |option_file| result.deep_merge!(option_file.parse(opts)) }

      opts[:symbolize_keys] ? result.deep_symbolize_keys : result
    end
  end
end
