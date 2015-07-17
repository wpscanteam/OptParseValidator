require 'spec_helper'

describe OptParseValidator::OptionsFile::JSON do
  subject(:file) { described_class.new(File.join(fixtures, fixture)) }
  let(:fixtures) { File.join(FIXTURES, 'options_file') }

  describe '#parse' do
    # Handled in options_files_spec.rb#parse
  end
end
