# encoding: UTF-8

class OptDirectoryPath < OptBase

  # @param [ String ] value
  #
  # @return [ String ] The path to the directory
  def validate(value)
    raise "The directory #{value} does not exist" unless Dir.exists?(value)
    value
  end

end
