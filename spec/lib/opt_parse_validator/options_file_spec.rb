# encoding: utf-8

require 'spec_helper'

describe OptParseValidator::OptParser do

  subject(:parser)    { OptParseValidator::OptParser.new }
  let(:fixtures)      { File.join(FIXTURES, 'options_file') }
  let(:default_file)  { File.join(fixtures, 'default.json') }
  let(:override_file) { File.join(fixtures, 'override.yml') }

  describe '#default_options_file=' do

    context 'when the file does not exist' do
      let(:file) { 'non_existant_file' }

      it 'raises an error' do
        exception = "The file #{file} was not found"
        expect { parser.default_options_file = file }.to raise_error(exception)
      end
    end

    context 'when the file exists' do
      it 'sets the instance variable' do
        parser.default_options_file = default_file
        parser.default_options_file.should == default_file
      end
    end

  end

  describe '#load_files' do

    context 'when the format is not supported' do
      let(:unsupported_file) { File.join(fixtures, 'unsupported.ext') }

      it 'raises an error' do
        exception = "The format #{File.extname(unsupported_file).delete('.')} is not supported"

        parser.add_potential_options_file(unsupported_file)
        expect { parser.load_files }.to raise_error(exception)
      end
    end

    context 'otherwise' do
      let(:opts) { [OptParseValidator::OptBoolean.new(%w{-v --verbose}), OptParseValidator::OptString.new(['--override-me VALUE'])] }

      let(:expected) { { verbose: true, override_me: 'Yeaa!' } }

      it 'sets everything correctly and get the right results' do
        parser.default_options_file = default_file
        parser.add_potential_options_file(override_file)
        parser.add(*opts)

        parser.results([]).should eq(expected)
      end
    end

  end

end
