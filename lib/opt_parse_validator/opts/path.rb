# frozen_string_literal: true

module OptParseValidator
  # Implementation of the Path Option
  class OptPath < OptBase
    # Initialize attrs:
    #
    # :create     if set to true, will create the path
    #
    # :exists     if set to false, will ignore the file? and directory? checks
    #
    # :file       Check if the path is a file
    # :directory  Check if the path is a directory
    #
    # :executable
    # :readable
    # :writable
    #

    # @param [ String ] value
    #
    # @return [ String ]
    def validate(value)
      path = Pathname.new(value)

      allowed_attrs.each do |key|
        method = "check_#{key}"
        send(method, path) if respond_to?(method) && attrs[key]
      end

      path.to_s
    end

    def allowed_attrs
      %i[create file directory executable readable writable]
    end

    # check_create is implemented in the file_path and directory_path opts

    # @param [ Pathname ] path
    def check_file(path)
      raise Error, "The path '#{path}' does not exist or is not a file" unless path.file? || attrs[:exists] == false
    end

    # @param [ Pathname ] path
    def check_directory(path)
      raise Error, "The path '#{path}' does not exist or is not a directory" unless path.directory? || attrs[:exists] == false
    end

    # @param [ Pathname ] path
    def check_executable(path)
      raise Error, "The path '#{path}' is not executable" unless path.executable?
    end

    # @param [ Pathname ] path
    def check_readable(path)
      raise Error, "The path '#{path}' is not readable" unless path.readable?
    end

    # If the path does not exist, it will check for the parent
    # directory write permission
    #
    # @param [ Pathname ] path
    def check_writable(path)
      raise Error, "The path '#{path}' is not writable" if (path.exist? && !path.writable?) || !path.parent.writable?
    end
  end
end
