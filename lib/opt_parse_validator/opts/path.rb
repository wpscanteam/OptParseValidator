module OptParseValidator
  # Implementation of the Path Option
  class OptPath < OptBase
    # Initialize attrs:
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
        send(method, path) if self.respond_to?(method) && attrs[key]
      end

      path.to_s
    end

    def allowed_attrs
      [:file, :directory, :executable, :readable, :writable]
    end

    # @param [ Pathname ] path
    def check_file(path)
      fail Error, "'#{path}' is not a file" unless path.file? || attrs[:exists] == false
    end

    # @param [ Pathname ] path
    def check_directory(path)
      fail Error, "'#{path}' is not a directory" unless path.directory? || attrs[:exists] == false
    end

    # @param [ Pathname ] path
    def check_executable(path)
      fail Error, "'#{path}' is not executable" unless path.executable?
    end

    # @param [ Pathname ] path
    def check_readable(path)
      fail Error, "'#{path}' is not readable" unless path.readable?
    end

    # If the path does not exist, it will check for the parent
    # directory write permission
    #
    # @param [ Pathname ] path
    def check_writable(path)
      fail Error, "'#{path}' is not writable" if path.exist? && !path.writable? || !path.parent.writable?
    end
  end
end
