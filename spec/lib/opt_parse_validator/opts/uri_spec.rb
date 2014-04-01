# encoding: utf-8

require 'spec_helper'

describe OptParseValidator::OptURI do

  subject(:opt) { described_class.new(['-u', '--uri URI'], attrs) }
  let(:attrs)   { {} }

  describe '#new, #allowed_protocols' do
    context 'when no attrs supplied' do
      its(:allowed_protocols) { should be_empty }
    end

    context 'when only one protocol supplied' do
      let(:attrs) { { protocols: 'http' } }

      it 'sets it' do
        opt.allowed_protocols << 'ftp'
        expect(opt.allowed_protocols).to eq %w(http ftp)
      end
    end

    context 'when multiple protocols are given' do
      let(:attrs) { { protocols: %w(ftp https) } }

      it 'sets them' do
        expect(opt.allowed_protocols).to eq attrs[:protocols]
      end
    end
  end

  describe '#validate' do
    context 'when the allowed_protocols is empty' do
      it 'accepts all protocols' do
        %w(http ftp file).each do |p|
          expected = "#{p}://testing"

          expect(opt.validate(expected)).to eq expected
        end
      end
    end

    context 'when allowed_protocols is set' do
      let(:attrs) { { protocols: %w(https) } }

      it 'raises an error if the protocol is not allowed' do
        expect { opt.validate('ftp://ishouldnotbethere') }
          .to raise_error(Addressable::URI::InvalidURIError)
      end

      it 'returns the uri string if valid' do
        expected = 'https://example.com/'

        expect(opt.validate(expected)).to eq expected
      end
    end
  end

end