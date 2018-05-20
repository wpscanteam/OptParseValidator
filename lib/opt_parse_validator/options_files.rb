require 'opt_parse_validator/options_file/base'
require 'opt_parse_validator/options_file/json'
require 'opt_parse_validator/options_file/yml'

module OptParseValidator
  # Options Files container
  class OptionsFiles < Array
    # @return [ Array<String> ] The downcased supported extensions list
    def supported_extensions
      extensions = OptionsFile.constants.select do |const|
        name = OptionsFile.const_get(const)
        name.is_a?(Class) && name != OptionsFile::Base
      end

      extensions.map { |sym| sym.to_s.downcase }
    end

    # @param [ String ] file_path
    #
    # @return [ Self ]
    def <<(file_path)
      return self unless File.exist?(file_path)

      ext = File.extname(file_path).delete('.')

      raise Error, "The option file's extension '#{ext}' is not supported" unless supported_extensions.include?(ext)

      super(OptionsFile.const_get(ext.upcase).new(file_path))
    end

    # @params [ Boolean ] symbolize_keys Whether or not to symbolize keys in the returned hash
    #
    # @return [ Hash ]
    def parse(symbolize_keys = false)
      result = {}

      each { |option_file| result.deep_merge!(option_file.parse) }

      symbolize_keys ? result.deep_symbolize_keys : result
    end
  end
end
