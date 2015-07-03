module OptParseValidator
  class Error < RuntimeError
  end

  class NoRequiredOption < Error
  end
end
