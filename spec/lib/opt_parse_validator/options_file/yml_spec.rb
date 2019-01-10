describe OptParseValidator::OptionsFile::YML do
  subject(:file) { described_class.new(fixtures.join(fixture)) }
  let(:fixtures) { FIXTURES.join('options_file') }

  describe '#parse' do
    # Handled in options_files_spec.rb#parse

    context 'when the file is empty' do
      let(:fixture) { 'empty_file' }

      its(:parse) { should eql({}) }
    end
  end
end
