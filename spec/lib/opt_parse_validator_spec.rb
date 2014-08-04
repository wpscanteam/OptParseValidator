require 'spec_helper'

describe OptParseValidator::OptParser do

  subject(:parser)  { described_class.new }
  let(:verbose_opt) { OptParseValidator::OptBase.new(%w(-v --verbose)) }
  let(:url_opt)     { OptParseValidator::OptURL.new(['-u', '--url URL'], required: true) }

  describe '#add_option' do
    after do
      if @exception
        expect { parser.add_option(@option) }.to raise_error(@exception)
      else
        parser.add_option(@option)

        expect(parser.symbols_used).to eq @expected_symbols
      end
    end

    context 'when not an OptBase' do
      it 'raises an error' do
        @option    = 'just a string'
        @exception = 'The option is not an OptBase, String supplied'
      end
    end

    context 'when the option symbol is already used' do
      it 'raises an error' do
        @option    = verbose_opt
        @exception = 'The option verbose is already used !'
        parser.add_option(@option)
      end
    end

    context 'when a valid option' do
      let(:option) { OptParseValidator::OptBase.new(['-u', '--url URL']) }

      it 'sets the option' do
        @option           = option
        @expected_symbols = [:url]
      end
    end
  end

  describe '#add' do
    context 'when not an Array<OptBase> or an OptBase' do
      after { expect { parser.add(*@options) }.to raise_error(@exception) }

      it 'raises an error when an Array<String>' do
        @options   = ['string', 'another one']
        @exception = 'The option is not an OptBase, String supplied'
      end
    end

    context 'when valid' do
      after do
        parser.add(*@options)

        expect(parser.symbols_used).to eq @expected_symbols
      end

      it 'adds the options' do
        @options          = [verbose_opt, url_opt]
        @expected_symbols = [:verbose, :url]
      end

      it 'adds the option' do
        @options          = verbose_opt
        @expected_symbols = [:verbose]
      end
    end
  end

  describe '#results' do
    before { parser.add(*options) }

    after do
      if @expected
        expect(parser.results(@argv)).to eq @expected
      else
        expect { parser.results(@argv) }.to raise_error(@exception)
      end
    end

    let(:options) { [verbose_opt, url_opt] }

    context 'when an option is required but not supplied' do
      it 'raises an error' do
        @exception = 'The option url is required'
        @argv      = %w(-v)
      end
    end

    context 'when the #validate raises an error' do
      it 'adds the option.to_long as a prefix' do
        @exception = Addressable::URI::InvalidURIError
        @argv      = %w(--url www.google.com)
      end
    end

    context 'when the default attribute is used' do
      let(:options)     { [verbose_opt, default_opt] }
      let(:default_opt) { OptParseValidator::OptBase.new(['--default VALUE'], default: false) }

      context 'when the option is supplied' do
        it 'overrides the default value' do
          @argv     = %w(--default overriden)
          @expected = { default: 'overriden' }
        end
      end

      context 'when the option is not supplied' do
        it 'sets the default value' do
          @argv     = %w(-v)
          @expected = { verbose: true, default: false }
        end
      end
    end

    # See https://github.com/wpscanteam/CMSScanner/issues/2
    context 'when no short option' do
      let(:options)  { [verbose_opt, http_opt] }
      let(:http_opt) { OptParseValidator::OptBase.new(['--http-auth log:pass']) }

      it 'calls the help' do
        expect(parser).to receive(:help)

        @argv      = %w(-h)
        @exception = SystemExit
      end

      it 'returns the results' do
        @argv     = %w(--http-auth user:passwd)
        @expected = { http_auth: 'user:passwd' }
      end
    end

    it 'returns the results' do
      @argv     = %w(--url http://hello.com -v)
      @expected = { url: 'http://hello.com', verbose: true }
    end
  end
end
