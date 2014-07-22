# encoding: utf-8

%w(base string integer positive_integer choice boolean uri url proxy credentials path file_path directory_path).each do |opt|
  require 'opt_parse_validator/opts/' + opt
end
