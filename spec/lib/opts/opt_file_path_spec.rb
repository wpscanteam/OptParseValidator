# encoding: UTF-8

require 'spec_helper'

describe OptFilePath do

  subject(:opt) { OptFilePath.new(['-f', '--file FILE']) }
  let(:file)    { 'a-simple-file-path' }

  describe '#validate' do
    context 'when the file does not exist' do
      it 'raises an error' do
        File.stub(:exists?).with(file).and_return(false)
        expect { opt.validate(file) }.to raise_error("The file #{file} does not exist")
      end
    end

    context 'when it exists' do
      it 'returns the file path' do
        File.stub(:exists?).with(file).and_return(true)
        opt.validate(file).should === file
      end
    end
  end

end
