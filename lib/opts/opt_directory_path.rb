# encoding: UTF-8

# Implemetantion of the DirectoryPath Option
# The directory must exist

class OptDirectoryPath < OptBase
  # @param [ String ] value
  #
  # @return [ String ] The path to the directory
  def validate(value)
    fail "The directory #{value} does not exist" unless Dir.exists?(value)
    value
  end
end
