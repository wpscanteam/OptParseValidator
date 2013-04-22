# encoding: UTF-8

require 'spec_helper'

describe CustomOptionParser do

  let(:parser) { CustomOptionParser.new }

  describe '#new' do

  end

  describe '#add_option' do
    context 'exception throwing if' do
      after :each do
        expect { parser.add_option(@option) }.to raise_error(@exception)
      end

      it 'argument passed is not an Array' do
        @option = 'a simple String'
        @exception = "The option must be an array, String supplied : 'a simple String'"
      end

      it 'option name is already used' do
        @option = ['-v', '--verbose', 'Verbose mode']
        parser.add_option(@option)
        @exception = 'The option verbose is already used !'
      end
    end

    it 'should have had 2 symbols (:verbose, :url) to @symbols_used' do
      parser.add_option(['-v', '--verbose'])
      parser.add_option(['--url TARGET_URL'])

      parser.symbols_used.sort.should === [:url, :verbose]
    end

    context 'parsing' do
      before :each do
        parser.add_option(['-u', '--url TARGET_URL', 'Set the target url'])
      end

      it 'should raise an error if an unknown option is supplied' do
        expect { parser.parse!(['--verbose']) }.to raise_error(OptionParser::InvalidOption)
      end

      it 'should raise an error if an option require an argument which is not supplied' do
        expect { parser.parse!(['--url']) }.to raise_error(OptionParser::MissingArgument)
      end

      it 'should retrieve the correct argument' do
        parser.parse!(['-u', 'iam_the_target'])
        parser.results.should === { url: 'iam_the_target' }
      end
    end
  end

  describe '#add' do
    it 'should raise an error if the argument is not an Array or Array(Array)' do
      expect { parser.add('Hello') }.to raise_error('Options must be at least an Array, or an Array(Array). String supplied')
    end

    before :each do
      parser.add(['-u', '--url TARGET_URL'])
    end

    context 'single option' do
      it 'should add the :url option, and retrieve the correct argument' do
        parser.symbols_used.should === [:url]
        parser.results(['-u', 'target.com']).should === { url: 'target.com' }
      end
    end

    context 'multiple options' do
      it 'should add 2 options, and retrieve the correct arguments' do
        parser.add([
          ['-v', '--verbose'],
          ['--test [TEST_NUMBER]']
        ])

        parser.symbols_used.sort.should === [:test, :url, :verbose]
        parser.results(['-u', 'wp.com', '-v', '--test']).should === { test: nil, url: 'wp.com', verbose: true }
      end
    end
  end

end
