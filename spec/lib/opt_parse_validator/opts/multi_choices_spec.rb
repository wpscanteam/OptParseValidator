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
    context 'when an unknown choice is given' do
      it 'raises an error' do
        expect { opt.validate('vp,n') }.to raise_error 'Unknown choice: n'
      end
    end

    context 'when nil or empty value' do
      context 'when no value_if_empty attribute' do
        it 'raises an error' do
          [nil, ''].each do |value|
            expect { opt.validate(value) }.to raise_error 'Empty option value supplied'
          end
        end
      end

      context 'when value_if_empty attribute' do
        let(:attrs) { super().merge(value_if_empty: 'vp,u') }

        it 'returns the expected hash' do
          [nil, ''].each do |value|
            expect(opt.validate(value)).to eql(vulenrable_plugins: true, users: (1..10))
          end
        end
      end
    end

    context 'when value' do
      it 'returns the expected hash' do
        expect(opt.validate('u2-5')).to eql(users: (2..5))
      end
    end
  end

  describe '#normalize' do
    it 'returns the same value (no normalization)' do
      expect(opt.normalize('a')).to eql 'a'
    end
  end
end
