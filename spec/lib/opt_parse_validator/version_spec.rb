require 'spec_helper'

describe OptParseValidator do
  it 'returns the version' do
    expect(OptParseValidator::VERSION).to be >= '0'
  end
end
