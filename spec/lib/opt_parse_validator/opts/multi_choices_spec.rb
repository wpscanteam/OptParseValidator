require 'spec_helper'

describe OptParseValidator::OptMultiChoices do
  subject(:opt) { described_class.new(['--enumerate [CHOICES]'], attrs) }
  let(:attrs) do
    {
      choices: {
        vp: OptParseValidator::OptBoolean.new(['--vulenrable-plugins']),
        u:  OptParseValidator::OptIntegerRange.new(['--users'], value_if_empty: '1-10')
      }
    }
  end

  describe '#new' do
    context 'when no choices attribute' do
      let(:attrs) { {} }

      it 'raises an error' do
        expect { opt }.to raise_error 'The :choices attribute is mandatory'
      end
    end

    context 'when choices attribute' do
      context 'when not a hash' do
        let(:attrs) { { choices: 'invalid' } }

        it 'raises an error' do
          expect { opt }.to raise_error 'The :choices attribute must be a hash'
        end
      end

      context 'when a hash' do
        it 'does not raise any error' do
          expect { opt }.to_not raise_error
        end
      end
    end
  end

  describe '#validate' do

  end
end
