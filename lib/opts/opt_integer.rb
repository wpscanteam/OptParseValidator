# encoding: UTF-8

class OptInteger < OptBase

  def validate(value)
    raise "#{value} is not an integer" if value.to_i.to_s != value
    value.to_i
  end

end
