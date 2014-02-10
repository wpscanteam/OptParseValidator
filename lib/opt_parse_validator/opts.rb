# encoding: utf-8

%w{base string integer boolean file_path directory_path uri url}.each do |suffix|
  require 'opt_parse_validator/opts/opt_' + suffix
end
