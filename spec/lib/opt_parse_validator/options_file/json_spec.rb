require 'spec_helper'

describe OptParseValidator::OptionsFile::JSON do
  subject(:file) { described_class.new('test.json') }

  describe '#parse' do
    # Handled in options_files_spec.rb#parse
  end
end
