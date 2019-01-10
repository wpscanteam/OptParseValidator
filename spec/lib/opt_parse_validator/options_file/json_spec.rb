describe OptParseValidator::OptionsFile::JSON do
  subject(:file) { described_class.new(fixtures.join(fixture)) }
  let(:fixtures) { FIXTURES.join('options_file') }

  describe '#parse' do
    # Handled in options_files_spec.rb#parse
  end
end
