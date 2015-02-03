require 'spec_helper'

describe OptParseValidator::OptArray do
  subject(:opt) { described_class.new(['-a', '--array VALUES']) }

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
end
