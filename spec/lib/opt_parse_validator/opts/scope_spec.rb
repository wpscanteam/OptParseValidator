require 'spec_helper'

describe OptParseValidator::OptScope do
  subject(:opt) { described_class.new(['--scope VALUES']) }

  describe '#validate' do
    context 'when an empty value is given' do
      it 'raises an error' do
        expect { opt.validate('') }.to raise_error('Empty option value supplied')
      end
    end

    context 'when an invalid scope is given' do
      it 'raises an error' do
        expect { opt.validate('*.x.com,x.invalid') }.to raise_error PublicSuffix::DomainInvalid
      end
    end

    it 'returns the expected array' do
      scope = ['*.x.com', '**.b.com', 'w.g.com'].map { |s| PublicSuffix.parse(s) }

      opt.validate('*.x.com,**.b.com,w.g.com').each_with_index do |value, index|
        expect(value).to be_a PublicSuffix::Domain
        expect(value.name).to eql scope[index].name
      end
    end
  end
end
