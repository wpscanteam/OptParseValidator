require 'json'
require 'yaml'

module OptParseValidator
  # TODO
  class OptParser < OptionParser
    attr_reader :default_options_file

    # @param [ String ] file_path
    #
    # @return [ Void ]
    def default_options_file=(file_path)
      if File.exists?(file_path)
        @default_options_file = file_path
      else
        fail "The file #{file_path} was not found"
      end
    end

    # The order in which this method is callled is important
    # TODO: Add the possibility to supply an array of potential file path
    #
    # @param [ String ] file_path
    #
    # @return [ Void ]
    def add_potential_options_file(file_path)
      @potential_options_files ||= []
      @potential_options_files << file_path
    end

    # Load the default options file and the options file
    #
    # @return [ Void ]
    def load_files
      file = guess_options_file

      parse_options_file(@default_options_file) if @default_options_file
      parse_options_file(file) if file
    end

    protected

    # Find the existing options file
    #
    # @return [ String ] The file path of the options file found
    def guess_options_file
      @potential_options_files ||= []

      @potential_options_files.reverse.each do |file_path|
        return file_path if File.exists?(file_path)
      end
      nil
    end

    # The file_path is supposed to be valid
    #
    # @param [ String ] file_path
    #
    # @return [ Hash ]
    def parse_options_file(file_path)
      file_ext       = File.extname(file_path).delete('.')
      method_to_call = "parse_#{file_ext}"

      if respond_to?(method_to_call, true) # The true allows to check protected & private methods
        data = method(method_to_call).call(file_path)

        @opts.each do |opt|
          # Annoying thing: the hash returned from parse_json & parse_yml is a string-full {"key"=>"value"}
          # and not a ruby hash {key: value} :/ As a result, symbol.to_s has to be used
          if data.key?(opt.symbol.to_s)
            @results[opt.symbol] = opt.validate(data[opt.symbol.to_s])
          end
        end
      else
        fail "The format #{file_ext} is not supported"
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
