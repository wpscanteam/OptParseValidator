# encoding: UTF-8

require 'spec_helper'

describe OptBoolean do
  subject(:opt) { OptBoolean.new(['-b', '--bool BOOL']) }

  describe '#validate' do
    context 'when does not match TRUE_PATTERN and FALSE_PATTERN' do
      it 'raises an error' do
        expect { opt.validate('a') }.
          to raise_error('Invalid boolean value, expected true|t|yes|y|1|false|f|no|n|0')
      end
    end

    context 'when matches TRUE_PATTERN' do
      after { opt.validate(@argument).should === true }

      %w{true t yes y 1}.each do |arg|
        it 'returns true' do
          @argument = arg
        end
      end
    end

    context 'when matches FALSE_PATTERN' do
      after { opt.validate(@argument).should === false }

      %w{false f no n 0}.each do |arg|
        it 'returns false' do
          @argument = arg
        end
      end
    end
  end

end
