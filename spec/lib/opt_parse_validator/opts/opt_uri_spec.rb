# encoding: utf-8

require 'spec_helper'

describe OptParseValidator::OptURI do

  subject(:opt) { OptParseValidator::OptURI.new(['-u', '--uri URI'], attrs) }
  let(:attrs)   { {} }

  describe '#new, #allowed_protocols' do
    context 'when no attrs supplied' do
      its(:allowed_protocols) { should be_empty }
    end

    context 'when allowed_option is not an array' do
      it 'raises an error' do
        expect { opt.allowed_protocols = 'invalid' }.to raise_error('Protocols must be an Array, String given')
      end
    end

    context 'when allowed_protocols is valid' do
      let(:attrs) { { protocols: %w{ftp https} } }

      it 'sets it' do
        opt.allowed_protocols.should eq(attrs[:protocols])
      end
    end
  end

  describe '#validate' do
    context 'when the allowed_protocols is empty' do
      it 'accepts all protocols' do
        %w{http ftp file}.each do |p|
          expected = "#{p}://testing"
          opt.validate(expected).should eq(expected)
        end
      end
    end

    context 'when allowed_protocols is set' do
      let(:attrs) { { protocols: %w{https} } }

      it 'raises an error if the protocol is not allowed' do
        expect { opt.validate('ftp://ishouldnotbethere') }.to raise_error(Addressable::URI::InvalidURIError)
      end

      it 'returns the uri string if valid' do
        expected = 'https://example.com/'

        opt.validate(expected).should eq(expected)
      end
    end
  end

end
