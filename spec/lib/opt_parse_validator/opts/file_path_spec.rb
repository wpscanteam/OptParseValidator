# encoding: utf-8

require 'spec_helper'

describe OptParseValidator::OptFilePath do

  subject(:opt) { described_class.new(['-f', '--file FILE']) }
  let(:file)    { 'a-simple-file-path' }

  describe '#validate' do
    context 'when the file does not exist' do
      it 'raises an error' do
        File.stub(:exist?).with(file).and_return(false)

        expect { opt.validate(file) }
          .to raise_error("The file #{file} does not exist")
      end
    end

    context 'when it exists' do
      it 'returns the file path' do
        File.stub(:exist?).with(file).and_return(true)

        expect(opt.validate(file)).to eq file
      end
    end
  end

end
