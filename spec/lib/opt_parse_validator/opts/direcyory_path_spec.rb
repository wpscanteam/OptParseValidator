# encoding: utf-8

require 'spec_helper'

describe OptParseValidator::OptDirectoryPath do

  subject(:opt) { described_class.new(['-d', '--dir DIR'], attrs) }
  let(:attrs)   { {} }
  let(:dir)     { File.join(FIXTURES, 'options_file') }

  its(:attrs) { should eq directory: true }

  describe '#validate' do
    context 'when it is a directory' do
      it 'returns the path' do
        expect(opt.validate(dir)).to eq dir
      end
    end

    context 'when it\s not ' do
      it 'raises an error' do
        expect { opt.validate('yolo.txt') }.to raise_error "'yolo.txt' is not a directory"
      end
    end
  end

end
