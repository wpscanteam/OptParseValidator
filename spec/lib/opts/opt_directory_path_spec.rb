# encoding: UTF-8

require 'spec_helper'

describe OptDirectoryPath do

  subject(:opt) { OptDirectoryPath.new(['-d', '--dir DIR']) }
  let(:dir)     { 'a-simple-directory-path' }

  describe '#validate' do
    context 'when the directory does not exist' do
      it 'raises an error' do
        Dir.stub(:exists?).with(dir).and_return(false)

        expect { opt.validate(dir) }.
          to raise_error("The directory #{dir} does not exist")
      end
    end

    context 'when it exists' do
      it 'returns the directory path' do
        Dir.stub(:exists?).with(dir).and_return(true)

        opt.validate(dir).should === dir
      end
    end
  end

end
