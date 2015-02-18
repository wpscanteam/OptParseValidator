require 'spec_helper'

describe OptParseValidator::OptMultiChoices do
  subject(:opt) { described_class.new(['--enumerate [CHOICES]'], attrs) }
  let(:attrs) do
    {
      choices: {
        vp: OptParseValidator::OptBoolean.new(['--vulnerable-plugins']),
        ap: OptParseValidator::OptBoolean.new(['--all-plugins']),
        p:  OptParseValidator::OptBoolean.new(['--plugins']),
        vt: OptParseValidator::OptBoolean.new(['--vulnerable-themes']),
        at: OptParseValidator::OptBoolean.new(['--all-themes']),
        t:  OptParseValidator::OptBoolean.new(['--themes']),
        tt: OptParseValidator::OptBoolean.new(['--timthumbs']),
        u:  OptParseValidator::OptIntegerRange.new(['--users'], value_if_empty: '1-10'),
        m:  OptParseValidator::OptIntegerRange.new(['--media'], value_if_empty: '1-100')
      }
    }
  end

  describe '#new' do
    context 'when no choices attribute' do
      let(:attrs) { {} }

      it 'raises an error' do
        expect { opt }.to raise_error 'The :choices attribute is mandatory'
      end
    end

    context 'when choices attribute' do
      context 'when not a hash' do
        let(:attrs) { { choices: 'invalid' } }

        it 'raises an error' do
          expect { opt }.to raise_error 'The :choices attribute must be a hash'
        end
      end

      context 'when a hash' do
        it 'does not raise any error' do
          expect { opt }.to_not raise_error
        end
      end
    end
  end

  describe '#validate' do
    context 'when an unknown choice is given' do
      it 'raises an error' do
        expect { opt.validate('vp,n') }.to raise_error 'Unknown choice: n'
      end
    end

    context 'when nil or empty value' do
      context 'when no value_if_empty attribute' do
        it 'raises an error' do
          [nil, ''].each do |value|
            expect { opt.validate(value) }.to raise_error 'Empty option value supplied'
          end
        end
      end

      context 'when value_if_empty attribute' do
        let(:attrs) { super().merge(value_if_empty: 'vp,u') }

        it 'returns the expected hash' do
          [nil, ''].each do |value|
            expect(opt.validate(value)).to eql(vulnerable_plugins: true, users: (1..10))
          end
        end
      end
    end

    context 'when value' do
      let(:attrs) do
        super().merge(incompatible: [
          [:vulnerable_plugins, :all_plugins, :plugins],
          [:vulnerable_themes, :all_themes, :themes]
        ])
      end

      it 'returns the expected hash' do
        expect(opt.validate('u2-5')).to eql(users: (2..5))
      end

      context 'when incompatible choices given' do
        it 'raises an error' do
          {
            'ap,p,t' => 'all_plugins, plugins',
            'ap,t,vp' => 'vulnerable_plugins, all_plugins',
            'ap,at,t' => 'all_themes, themes'
          }.each do |value, msg|
            expect { opt.validate(value) }.to raise_error "Incompatible choices detected: #{msg}"
          end
        end
      end
    end
  end

  describe '#normalize' do
    it 'returns the same value (no normalization)' do
      expect(opt.normalize('a')).to eql 'a'
    end
  end
end
