# encoding: UTF-8

class OptFilePath < OptBase

  # @param [ String ] value
  #
  # @return [ String ] The path to the file
  def validate(value)
    raise "The file #{value} does not exist" unless File.exists?(value)
    value
  end

end
