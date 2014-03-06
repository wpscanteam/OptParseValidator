# encoding: utf-8

require 'spec_helper'

describe OptParseValidator::OptParser do

  subject(:parser)    { OptParseValidator::OptParser.new }
  let(:fixtures)      { File.join(FIXTURES, 'options_file') }
  let(:default_file)  { File.join(fixtures, 'default.json') }
  let(:override_file) { File.join(fixtures, 'override.yml') }

  describe '#load_options_files' do

    context 'when the format is not supported' do
      let(:unsupported_file) { File.join(fixtures, 'unsupported.ext') }

      it 'raises an error' do
        exception = "The format #{File.extname(unsupported_file).delete('.')} is not supported"

        parser.options_files << unsupported_file

        expect { parser.load_options_files }.to raise_error(exception)
      end
    end

    context 'otherwise' do
      let(:opts) { [OptParseValidator::OptBoolean.new(%w{-v --verbose}), OptParseValidator::OptString.new(['--override-me VALUE'])] }

      let(:expected) { { verbose: true, override_me: 'Yeaa!' } }

      it 'sets everything correctly and get the right results' do
        parser.options_files << default_file << override_file
        parser.add(*opts)

        parser.results([]).should eq(expected)
      end
    end

  end

end
