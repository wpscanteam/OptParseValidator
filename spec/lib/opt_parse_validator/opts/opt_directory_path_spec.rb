# encoding: utf-8

require 'spec_helper'

describe OptParseValidator::OptDirectoryPath do

  subject(:opt) { OptParseValidator::OptDirectoryPath.new(['-d', '--dir DIR']) }
  let(:dir)     { 'a-simple-directory-path' }

  describe '#validate' do
    context 'when the directory does not exist' do
      it 'raises an error' do
        Dir.stub(:exist?).with(dir).and_return(false)

        expect { opt.validate(dir) }
          .to raise_error("The directory #{dir} does not exist")
      end
    end

    context 'when it exists' do
      it 'returns the directory path' do
        Dir.stub(:exist?).with(dir).and_return(true)

        opt.validate(dir).should eq(dir)
      end
    end
  end

end
