require 'spec_helper'

describe OptParseValidator::OptArray do
  subject(:opt) { described_class.new(['-a', '--array VALUES'], attrs) }
  let(:attrs)   { {} }

  describe '#validate' do
    context 'when an empty value is given' do
      it 'raises an error' do
        expect { opt.validate('') }.to raise_error('Empty option value supplied')
      end
    end

    context 'when the separator is not supplied' do
      context 'when not present in the argument' do
        it 'returns an array with the correct value' do
          expect(opt.validate('rspec')).to eql %w(rspec)
        end
      end

      context 'when present' do
        it 'returns the expected array' do
          expect(opt.validate('r1,r2,r3')).to eql %w(r1 r2 r3)
        end
      end
    end

    context 'when separator supplied' do
      subject(:opt) { described_class.new(['-a', '--array VALUES'], separator: '-') }

      it 'returns an array with the correct value' do
        expect(opt.validate('r1,r2,r3')).to eql %w(r1,r2,r3)
      end

      it 'returns the expected array' do
        expect(opt.validate('r1-r2-r3')).to eql %w(r1 r2 r3)
      end
    end
  end

  describe '#normalize' do
    after { expect(opt.normalize(@value)).to eql @expected }

    context 'when no :normalize attribute' do
      it 'returns the value' do
        @value    = %w(t1 t2)
        @expected = @value
      end
    end

    context 'when a single normalization' do
      let(:attrs) { { normalize: :to_sym } }

      it 'returns the expected value' do
        @value    = [1.0, 'test']
        @expected = [1.0, :test]
      end
    end
  end
end