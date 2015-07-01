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
        t:  OptParseValidator::OptBoolean.new(['--themes', 'Themes Spec']),
        tt: OptParseValidator::OptBoolean.new(['--timthumbs']),
        u:  OptParseValidator::OptIntegerRange.new(['--users', 'User ids Range, e.g: u1-20, u'], value_if_empty: '1-10'),
        m:  OptParseValidator::OptIntegerRange.new(['--media'], value_if_empty: '1-100')
      },
      incompatible: [[:ap, :vp, :p], [:vt, :at, :t]]
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

  describe '#append_help_messages' do
    let(:attrs) { super().merge(value_if_empty: 'vp,vt,tt,u,m') }

    its(:help_messages) do
      should eql [
        'Available Choices:',
        ' vp  Vulnerable plugins',
        ' ap  All plugins',
        ' p   Plugins',
        ' vt  Vulnerable themes',
        ' at  All themes',
        ' t   Themes Spec',
        ' tt  Timthumbs',
        ' u   User ids Range, e.g: u1-20, u',
        "     Range separator to use: '-'",
        '     If no range is supplied, 1-10 will be used',
        " m   Range separator to use: '-'",
        '     If no range is supplied, 1-100 will be used',
        "Multiple choices can be supplied, use the ',' char as a separator",
        "If no choice is supplied, 'vp,vt,tt,u,m' will be used",
        'Incompatible choices (only one of each group/s can be used):',
        ' - ap, vp, p',
        ' - vt, at, t'
      ]
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
      it 'returns the expected hash' do
        expect(opt.validate('u2-5')).to eql(users: (2..5))
      end

      context 'when incompatible choices given' do
        it 'raises an error' do
          {
            'ap,p,t' => 'ap, p',
            'ap,t,vp' => 'ap, vp',
            'ap,at,t' => 'at, t'
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
