module OptParseValidator
  # Implementation of the Credentials Option
  class OptCredentials < OptBase
    # @return [ Hash ] A hash containing the :username and :password
    def validate(value)
      unless value.index(':')
        raise Error, 'Incorrect credentials format, username:password expected'
      end
      creds = value.split(':', 2)

      { username: creds[0], password: creds[1] }
    end
  end
end
