# encoding: utf-8

require 'spec_helper'

describe OptParseValidator::OptParser do

  subject(:parser)  { OptParseValidator::OptParser.new }
  let(:verbose_opt) { OptParseValidator::OptBase.new(%w(-v --verbose)) }
  let(:url_opt)     { OptParseValidator::OptBase.new(['-u', '--url URL'], required: true) }

  describe '#add_option' do
    after do
      if @exception
        expect { parser.add_option(@option) }.to raise_error(@exception)
      else
        parser.add_option(@option)
        parser.symbols_used.should eq(@expected_symbols)
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
        parser.symbols_used.should eq(@expected_symbols)
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
    after do
      parser.add(*options)

      if @expected
        parser.results(@argv).should eq(@expected)
      else
        expect { parser.results(@argv) }.to raise_error(@exception)
      end
    end

    let(:options) { [verbose_opt, url_opt] }

    context 'when an option is required but not supplied' do
      it 'raises an error' do
        @exception = 'The option url is required'
        @argv      = ['-v']
      end
    end

    it 'returns the results' do
      @argv     = %w(--url hello.com -v)
      @expected = { url: 'hello.com', verbose: true }
    end
  end
end
