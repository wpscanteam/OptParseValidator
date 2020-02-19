require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config do |c|
  c.single_report_path = 'coverage/locv.info'
  c.report_with_single_file = true
end

SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter

SimpleCov.start do
  # enable_coverage :branch
  add_filter '/spec/'
  add_filter '_helper.rb'
end
