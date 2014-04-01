# encoding: utf-8

%w(base string integer boolean file_path directory_path uri url proxy credentials).each do |opt|
  require 'opt_parse_validator/opts/' + opt
end
