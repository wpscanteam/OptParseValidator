# frozen_string_literal: true

describe OptParseValidator::ConfigFilesLoaderMerger do
  subject(:files)     { described_class.new }
  let(:fixtures)      { FIXTURES.join('config_files_loader_merger') }
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
          OptParseValidator::ConfigFilesLoaderMerger::ConfigFile::JSON.new(default_file),
          OptParseValidator::ConfigFilesLoaderMerger::ConfigFile::YML.new(override_file)
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
        expect(files.parse(symbolize_keys: true)).to eql(expected_hash.deep_symbolize_keys)
      end
    end

    context 'when YAML class not whitelisted' do
      before { files << fixtures.join('regexp_class.yml') }

      it 'raises an error' do
        expect { files.parse }.to raise_error(Psych::DisallowedClass)
      end

      context 'when the class is whitelisted' do
        it 'returns the regexp' do
          results = files.parse(yaml_options: { permitted_classes: [Regexp] }, symbolize_keys: true)

          expect(results[:pattern]).to eql(/some (regexp)/i)
        end
      end
    end
  end
end
