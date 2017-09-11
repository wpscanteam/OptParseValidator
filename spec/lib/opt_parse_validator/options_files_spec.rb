require 'spec_helper'

describe OptParseValidator::OptionsFiles do
  subject(:files)     { described_class.new }
  let(:fixtures)      { File.join(FIXTURES, 'options_file') }
  let(:default_file)  { File.join(fixtures, 'default.json') }
  let(:override_file) { File.join(fixtures, 'override.yml') }

  describe '#supported_extensions' do
    its(:supported_extensions) { %w[json yml] }
  end

  describe '#<<' do
    context 'when the file does not exist' do
      it 'returns self' do
        expect(files << 'not-there.json').to eql files
      end
    end

    context 'when the format is not supported' do
      it 'raises an error' do
        expect { files << File.join(fixtures, 'unsupported.ext') }
          .to raise_error(
            OptParseValidator::Error,
            "The option file's extension 'ext' is not supported"
          )
      end
    end

    context 'when the format is supported' do
      it 'adds the file' do
        files << default_file << override_file

        expect(files).to eq [
          OptParseValidator::OptionsFile::JSON.new(default_file),
          OptParseValidator::OptionsFile::YML.new(override_file)
        ]
      end
    end
  end

  describe '#parse' do
    before { files << default_file << override_file }

    its(:parse) { should eql(verbose: true, override_me: 'Yeaa') }
  end
end
