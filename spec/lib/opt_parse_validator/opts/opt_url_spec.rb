# encoding: utf-8

require 'spec_helper'

describe OptParseValidator::OptURL do

  subject(:opt) { OptParseValidator::OptURL.new(['-u', '--url URL']) }

  describe '#validate' do
    context 'when the url is empty' do
      it 'raises an error' do
        expect { opt.validate('') }.to raise_error(Addressable::URI::InvalidURIError)
      end
    end

    context 'when the protocol is not allowed' do
      it 'raises an error' do
        expect { opt.validate('ftp://ftp.domain.com') }.to raise_error(Addressable::URI::InvalidURIError)
      end
    end

    it 'returns the url' do
      url = 'https://duckduckgo.com/'

      opt.validate(url).should eq(url)
    end
  end

end
