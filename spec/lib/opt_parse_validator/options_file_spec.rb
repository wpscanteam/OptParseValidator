require 'spec_helper'

describe OptParseValidator::OptParser do
  subject(:parser)     { described_class.new }
  let(:fixtures)       { File.join(FIXTURES, 'options_file') }
  let(:default_file)   { File.join(fixtures, 'default.json') }
  let(:override_file)  { File.join(fixtures, 'override.yml') }

  describe '#load_options_files' do
    context 'when error' do
      before { parser.options_files << config_file }

      context 'when the format is not supported' do
        let(:config_file) { File.join(fixtures, 'unsupported.ext') }
        
        it 'raises an error' do
          expect { parser.load_options_files }
            .to raise_error(
              OptParseValidator::Error,
              "The format #{File.extname(config_file).delete('.')} is not supported"
            )
        end
      end

      context 'when file content is malformed' do
        let(:config_file) { File.join(fixtures, 'malformed.json') }
        
        it 'raises an error' do
          expect { parser.load_options_files }
            .to raise_error(OptParseValidator::Error, "Parse Error, #{config_file} seems to be malformed")
        end
      end
    end

    context 'otherwise' do
      let(:verbose_opt) { OptParseValidator::OptBoolean.new(%w(-v --verbose)) }
      let(:override_opt) { OptParseValidator::OptString.new(['--override-me VALUE'], normalize: :to_sym) }

      let(:opts) { [verbose_opt, override_opt] }

      let(:expected) { { verbose: true, override_me: :Yeaa } }

      it 'sets everything correctly and get the right results' do
        parser.options_files << default_file << override_file
        parser.add(*opts)

        expect(parser.results([])).to eq expected
      end
    end
  end
end
