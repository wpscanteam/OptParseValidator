# encoding: UTF-8

class OptInteger < OptBase

  def validate(value)
    if value.to_i.to_s != value
      raise "#{value} is not an integer"
    end
    value.to_i
  end

end
