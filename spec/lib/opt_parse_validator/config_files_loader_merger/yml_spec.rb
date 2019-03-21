# frozen_string_literal: true

describe OptParseValidator::ConfigFilesLoaderMerger::ConfigFile::YML do
  subject(:file) { described_class.new(fixtures.join(fixture)) }
  let(:fixtures) { FIXTURES.join('config_files_loader_merger') }

  describe '#parse' do
    # Handled in options_files_spec.rb#parse

    context 'when the file is empty' do
      let(:fixture) { 'empty_file' }

      its(:parse) { should eql({}) }
    end

    context 'when file contains classes' do
      let(:fixture) { 'regexp_class.yml' }

      context 'when the class is not whitelisted (default behaviour)' do
        it 'raises an error' do
          expect { file.parse }.to raise_error(Psych::DisallowedClass)
        end
      end

      context 'when the class is whitelisted' do
        it 'returns the regexp' do
          result = file.parse(yaml_arguments: [[Regexp]])

          expect(result['pattern']).to be_a Regexp
          expect(result['pattern']).to eql(/some (regexp)/i)
        end
      end
    end
  end
end
