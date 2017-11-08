require 'spec_helper'

describe OptParseValidator::OptParser do
  subject(:parser)  { described_class.new }
  let(:verbose_opt) { OptParseValidator::OptBoolean.new(%w[-v --verbose]) }
  let(:url_opt)     { OptParseValidator::OptURL.new(['-u', '--url URL'], required: true) }

  describe '#add_option' do
    after do
      if @exception
        expect { parser.add_option(@option) }.to raise_error(*@exception)
      else
        parser.add_option(@option)

        expect(parser.symbols_used).to eq @expected_symbols
      end
    end

    context 'when not an OptBase' do
      it 'raises an error' do
        @option    = 'just a string'
        @exception = OptParseValidator::Error, 'The option is not an OptBase, String supplied'
      end
    end

    context 'when the option symbol is already used' do
      it 'raises an error' do
        @option    = verbose_opt
        @exception = OptParseValidator::Error, 'The option verbose is already used !'
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
      after { expect { parser.add(*@options) }.to raise_error(*@exception) }

      it 'raises an error when an Array<String>' do
        @options   = ['string', 'another one']
        @exception = OptParseValidator::Error, 'The option is not an OptBase, String supplied'
      end
    end

    context 'when valid' do
      after do
        parser.add(*@options)

        expect(parser.symbols_used).to eq @expected_symbols
      end

      it 'adds the options' do
        @options          = [verbose_opt, url_opt]
        @expected_symbols = %i[verbose url]
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
        expect { parser.results(@argv) }.to raise_error(*@exception)
      end
    end

    let(:options) { [verbose_opt, url_opt] }

    context 'when an option is required but not supplied' do
      it 'raises an error' do
        @exception = OptParseValidator::NoRequiredOption, 'The option url is required'
        @argv      = %w[-v]
      end
    end

    context 'when the #validate raises an error' do
      it 'adds the option.to_long as a prefix' do
        @exception = OptParseValidator::Error, '--url Addressable::URI::InvalidURIError'
        @argv      = %w[--url www.google.com]
      end
    end

    context 'when :requied_unless' do
      let(:url_opt)    { OptParseValidator::OptURL.new(['--url URL'], required_unless: :update) }
      let(:update_opt) { OptParseValidator::OptBoolean.new(['--update'], required_unless: [:url]) }
      let(:options)    { [url_opt, update_opt, verbose_opt] }

      context 'when none supplied' do
        it 'raises an error' do
          @exception = OptParseValidator::NoRequiredOption, 'One of the following options is required: url, update'
          @argv      = %w[-v]
        end
      end

      context 'when --url' do
        it 'returns the expected value' do
          @expected = { url: 'http://www.g.com' }
          @argv     = %w[--url http://www.g.com]
        end
      end

      context 'when --update' do
        it 'returns the expected value' do
          @expected = { update: true }
          @argv     = %w[--update]
        end
      end

      context 'when --url and --update' do
        it 'returns the expected values' do
          @expected = { url: 'http://www.g.com', update: true, verbose: true }
          @argv     = %w[--url http://www.g.com --update -v]
        end
      end
    end

    context 'when the default attribute is used' do
      let(:options)     { [verbose_opt, default_opt] }
      let(:default_opt) { OptParseValidator::OptBase.new(['--default VALUE'], default: false) }

      context 'when the option is supplied' do
        it 'overrides the default value' do
          @argv     = %w[--default overriden]
          @expected = { default: 'overriden' }
        end
      end

      context 'when the option is not supplied' do
        it 'sets the default value' do
          @argv     = %w[-v]
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

        @argv      = %w[-h]
        @exception = SystemExit
      end

      it 'returns the results' do
        @argv     = %w[--http-auth user:passwd]
        @expected = { http_auth: 'user:passwd' }
      end
    end

    context 'when the normalize attrbite is used' do
      let(:options) { [OptParseValidator::OptString.new(['--test V'], normalize: :to_sym)] }

      it 'returns the symbol' do
        @argv     = %w[--test test]
        @expected = { test: :test }
      end
    end

    it 'returns the results' do
      @argv     = %w[--url http://hello.com -v]
      @expected = { url: 'http://hello.com', verbose: true }
    end
  end

  describe '#load_options_files' do
    let(:fixtures)       { File.join(FIXTURES, 'options_file') }
    let(:default_file)   { File.join(fixtures, 'default.json') }
    let(:override_file)  { File.join(fixtures, 'override.yml') }
    let(:malformed_file) { File.join(fixtures, 'malformed.yml') }
    let(:override_opt)   { OptParseValidator::OptString.new(['--override-me VALUE'], normalize: :to_sym) }
    let(:opts)           { [verbose_opt, override_opt] }
    let(:expected)       { { verbose: true, override_me: :Yeaa } }

    before do
      parser.options_files << default_file << override_file
      parser.add(*opts)
    end

    context 'when the file is malformed' do
      before { parser.options_files << malformed_file }

      it 'raises an OptParseValidator::Error' do
        expect { parser.results([]) }.to raise_error OptParseValidator::Error
      end
    end

    context 'when no cli options supplied' do
      it 'sets everything correctly and get the right results' do
        expect(parser.results([])).to eql expected
      end
    end

    context 'when cli options provided' do
      it 'prioritize the cli one' do
        expect(parser.results(%w[--override-me cli])).to eql expected.merge(override_me: :cli)
      end
    end

    context 'when multi choices given as boolean in options file' do
      let(:enum_file) { File.join(fixtures, 'enum.yml') }
      let(:enum_opt) do
        OptParseValidator::OptMultiChoices.new(
          ['--enum [Options]'],
          choices: {
            a: OptParseValidator::OptBoolean.new(['--aa']),
            b: OptParseValidator::OptBoolean.new(['--bb'])
          },
          value_if_empty: 'a,b'
        )
      end

      before do
        parser.options_files << enum_file
        parser.add(enum_opt)
      end

      it 'raises an error' do
        expect { parser.results([]) }.to raise_error(OptParseValidator::Error, 'Unknown choice: true')
      end
    end
  end
end
