describe OptParseValidator::OptionsFiles do
  subject(:files)     { described_class.new }
  let(:fixtures)      { FIXTURES.join('options_file') }
  let(:default_file)  { fixtures.join('default.json') }
  let(:override_file) { fixtures.join('override.yml') }

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
        expect { files << fixtures.join('unsupported.ext') }
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
    let(:expected_hash) do
      {
        'verbose' => true, 'override_me' => 'Yeaa',
        'deep_merge' => { 'p1' => 'v2', 'p2' => 'v3' }
      }
    end

    its(:parse) { should eql(expected_hash) }

    context 'when symbolize_keys argument' do
      it 'returns the hash with the keys as symbol' do
        expect(files.parse(true)).to eql(expected_hash.deep_symbolize_keys)
      end
    end
  end
end
