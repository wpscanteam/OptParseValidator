require 'spec_helper'

describe OptParseValidator::OptScope do
  subject(:opt) { described_class.new(['--scope VALUES']) }

  describe '#validate' do
    context 'when an empty value is given' do
      it 'raises an error' do
        expect { opt.validate('') }.to raise_error('Empty option value supplied')
      end
    end

    it 'returns the expected array' do
      scope = ['*.x.com', '**.b.com', 'w.g.com'].map { |s| PublicSuffix.parse(s) }
      scope << 'wp.lab' << '192.168.1.12'

      expect(opt.validate('*.x.com,**.b.com,w.g.com,wp.lab,192.168.1.12')).to eq scope
    end
  end
end
