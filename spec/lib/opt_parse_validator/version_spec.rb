# encoding: utf-8

require 'spec_helper'

describe OptParseValidator do
  it 'returns the version' do
    OptParseValidator::VERSION.should >= '0'
  end
end
