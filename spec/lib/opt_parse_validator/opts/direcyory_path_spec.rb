require 'spec_helper'

describe OptParseValidator::OptDirectoryPath do
  subject(:opt)  { described_class.new(['-d', '--dir DIR'], attrs) }
  let(:attrs)    { {} }
  let(:dir_path) { FIXTURES.join('options_file').to_s }

  its(:attrs) { should eq directory: true }

  describe '#validate' do
    context 'when it is a directory' do
      it 'returns the path' do
        expect(opt.validate(dir_path)).to eql dir_path
      end
    end

    context 'when it\'s not ' do
      it 'raises an error' do
        expect { opt.validate('yolo.txt') }.to raise_error "'yolo.txt' is not a directory"
      end
    end

    context 'when :create' do
      let(:attrs) { { create: true } }

      context 'when the directory exists' do
        it 'does not create it' do
          expect(FileUtils).to_not receive(:mkdir_p)

          expect(opt.validate(dir_path)).to eql dir_path
        end
      end

      context 'when the file does not exist' do
        let(:dir_path) { FIXTURES.join('dir_path').to_s }

        it 'creates it' do
          expect(opt.validate(dir_path)).to eql dir_path
          expect(Dir.exist?(dir_path)).to eql true

          FileUtils.remove_dir(dir_path)
        end
      end
    end
  end
end
