# encoding: UTF-8

require 'spec_helper'

describe OptBase do
  subject(:opt) { OptBase.new(option, attrs) }
  let(:option)  { ['-v', '--verbose'] }
  let(:attrs)   { {} }

  describe '::find_symbol' do
    after :each do
      if @exception
        expect { OptBase.find_symbol(@option) }.to raise_error(@exception)
      else
        OptBase.find_symbol(@option).should === @expected
      end
    end

    context 'without REQUIRED or OPTIONAL arguments' do
      context 'with short option' do
        it 'returns :test' do
          @option   = ['-t', '--test', 'Testing']
          @expected = :test
        end

        it 'returns :its_a_long_option' do
          @option   = ['-l', '--its-a-long-option', "Testing '-' replacement"]
          @expected = :its_a_long_option
        end
      end

      context 'without short option' do
        it 'returns :long' do
          @option   = ['--long']
          @expected = :long
        end

        it 'returns :long_option' do
          @option   = ['--long-option', 'No short !']
          @expected = :long_option
        end
      end

      context 'without long option' do
        it 'raises an arror' do
          @option    = ['-v', 'long option missing']
          @exception = 'Could not find option symbol for ["-v", "long option missing"]'
        end

        it 'raises an error' do
          @option    = ['long option missing']
          @exception = 'Could not find option symbol for ["long option missing"]'
        end
      end

      context 'with multiple long option names (like alias)' do
        it 'returns the first long option found' do
          @option   = ['--check-long', '--cl']
          @expected = :check_long
        end
      end
    end

    context 'when negative prefix name' do
      it 'returns the positive option symbol' do
        @option   = ['-v', '--[no-]verbose']
        @expected = :verbose
      end
    end

    context 'with REQUIRED or OPTIONAL arguments' do
      it 'should removed the OPTIONAL argument' do
        @option   = ['-p', '--page [PAGE_NUMBER]']
        @expected = :page
      end

      it 'should removed the REQUIRED argument' do
        @option   = ['--url TARGET_URL']
        @expected = :url
      end
    end
  end

  describe '#new, #required?' do
    context 'when no :required' do
      its(:option)    { should === option }
      its(:required?) { should be_false }
      its(:symbol)    { should === :verbose }
    end

    context 'when :required' do
      let(:attrs) { { required: true } }

      its(:required?) { should be_true }
    end

  end

  describe '#validate' do
    context 'when an empty or nil value' do
      it 'raises an error' do
        [nil, ''].each do |value|
          expect { opt.validate(value) }.
            to raise_error('Empty option value supplied')
        end
      end
    end

    context 'when a valid value' do
      it 'returns it' do
        opt.validate('testing').should == 'testing'
      end
    end
  end

end
