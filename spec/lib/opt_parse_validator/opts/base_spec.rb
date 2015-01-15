require 'spec_helper'

describe OptParseValidator::OptBase do
  subject(:opt) { described_class.new(option, attrs) }
  let(:option)  { %w(-v --verbose) }
  let(:attrs)   { {} }

  describe '#to_long' do
    after { expect(described_class.new(@option).to_long).to eq @expected }

    context 'when not found' do
      it 'returns nil' do
        @option = %w(-v)
        @expected = nil
      end
    end

    context 'when found' do
      it 'returns the long name' do
        @option = ['-v', '--[no-]verbose VALUE [OPT]', 'Verbose Mode']
        @expected = '--verbose'
      end
    end
  end

  describe '#to_sym' do
    after :each do
      if @exception
        expect { described_class.new(@option).to_sym }.to raise_error(@exception)
      else
        expect(described_class.new(@option).to_sym).to eq(@expected)
      end
    end

    context 'without REQUIRED or OPTIONAL arguments' do
      context 'with short option' do
        it 'returns :test' do
          @option   = %w(-t --test Testing)
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
        it 'raises an error' do
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
          @option   = %w(--check-long --cl)
          @expected = :check_long
        end
      end
    end

    context 'when negative prefix name' do
      it 'returns the positive option symbol' do
        @option   = %w(-v --[no-]verbose)
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
      its(:option)    { should eq(option) }
      its(:required?) { should be_falsey }
      its(:to_sym)    { should eq(:verbose) }
    end

    context 'when :required' do
      let(:attrs) { { required: true } }

      its(:required?) { should be true }
    end
  end

  describe '#normalize' do
    after { expect(opt.normalize(@value)).to eq @expected }

    context 'when no :normalize attribute' do
      it 'returns the value' do
        @value    = 'test'
        @expected = @value
      end
    end

    context 'when a single normalization' do
      let(:attrs) { { normalize: :to_sym } }

      context 'when the value does not have a to_sym method' do
        it 'returns the value' do
          @value    = 1.0
          @expected = @value
        end
      end

      context 'when a to_sym method' do
        it 'returns the symbol' do
          @value    = 'test'
          @expected = :test
        end
      end
    end

    context 'when multiple normalization' do
      let(:attrs) { { normalize: [:to_sym, 2.0, :upcase] } }

      it 'apply each of them (if possible)' do
        @value    = 'test'
        @expected = :TEST
      end
    end
  end

  describe '#validate' do
    context 'when an empty or nil value' do
      it 'raises an error' do
        [nil, ''].each do |value|
          expect { opt.validate(value) }
            .to raise_error('Empty option value supplied')
        end
      end
    end

    context 'when a valid value' do
      it 'returns it' do
        expect(opt.validate('testing')).to eq 'testing'
      end
    end
  end
end
