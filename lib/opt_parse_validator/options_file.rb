require 'json'
require 'yaml'

module OptParseValidator
  # TODO
  class OptParser < OptionParser
    def options_files
      @options_files ||= []
    end

    def load_options_files
      files_data = {}

      options_files.each do |file|
        data = parse_file(file)
        files_data.merge!(data) if data
      end

      @opts.each do |opt|
        # Annoying thing: the hash returned from parse_file is a string-full {"key"=>"value"}
        # and not a ruby hash {key: value} :/ As a result, symbol.to_s has to be used
        next unless files_data.key?(opt.to_sym.to_s)

        @results[opt.to_sym] = opt.normalize(opt.validate(files_data[opt.to_sym.to_s]))
      end
    end

    protected

    # @param [ String ] file_path
    #
    # @return [ Hash ]
    def parse_file(file_path)
      return unless File.exist?(file_path)

      file_ext       = File.extname(file_path).delete('.')
      method_to_call = "parse_#{file_ext}"

      fail Error, "The format #{file_ext} is not supported" unless respond_to?(method_to_call, true) # The true allows to check protected & private methods

      begin
        method(method_to_call).call(file_path)
      rescue
        raise Error, "Parse Error, #{file_path} seems to be malformed"
      end
    end

    # @param [ String ] file_path
    #
    # @return [ Hash ]
    def parse_json(file_path)
      JSON.parse(File.read(file_path))
    end

    # @param [ String ] file_path
    #
    # @return [ Hash ]
    def parse_yml(file_path)
      YAML.load_file(file_path)
    end
  end
end
