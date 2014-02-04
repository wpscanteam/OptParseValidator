# encoding: UTF-8

require 'spec_helper'

describe OptParseValidator::OptInteger do

  subject(:opt) { OptParseValidator::OptInteger.new(['-i', '--int INT']) }

  describe '#validate' do
    context 'when not an integer' do
      it 'raises an error' do
        expect { opt.validate('a') }.to raise_error('a is not an integer')
      end
    end

    it 'returns the integer' do
      opt.validate('12').should eq(12)
    end
  end

end
