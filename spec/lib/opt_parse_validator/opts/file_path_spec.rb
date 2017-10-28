require 'spec_helper'

describe OptParseValidator::OptFilePath do
  subject(:opt)   { described_class.new(['-f', '--file FILE_PATH'], attrs) }
  let(:attrs)     { {} }
  let(:file_path) { File.join(FIXTURES, 'file_path.txt') }

  its(:attrs)     { should eq file: true }

  describe '#validate' do
    context 'when :extensions' do
      let(:attrs) { { extensions: 'txt' } }

      its('allowed_attrs.first') { should eq :extensions }

      context 'when it matches' do
        it 'returns the path' do
          expect(opt.validate(file_path)).to eql file_path
        end
      end

      context 'when it does no match' do
        it 'raises an error' do
          expect { opt.validate('yolo.aa') }
            .to raise_error(OptParseValidator::Error, "The extension of 'yolo.aa' is not allowed")
        end
      end
    end

    context 'when :create' do
      let(:attrs) { { create: true } }

      context 'when the file exists' do
        it 'does not create it' do
          expect(FileUtils).to_not receive(:touch)

          expect(opt.validate(file_path)).to eql file_path
        end
      end

      context 'when the file does not exist' do
        let(:file_path) { File.join(FIXTURES, 'file_path2.txt') }

        it 'creates it' do
          expect(opt.validate(file_path)).to eql file_path
          expect(File.exist?(file_path)).to eql true
        end
      end
    end

    context 'when :executable' do
      let(:attrs) { { executable: true } }

      it 'returns the path if executable' do
        expect_any_instance_of(Pathname).to receive(:executable?).and_return(true)

        expect(opt.validate(file_path)).to eql file_path
      end

      it 'raises an error if not ' do
        expect { opt.validate(file_path) }.to raise_error(OptParseValidator::Error, "'#{file_path}' is not executable")
      end
    end

    context 'when :readable' do
      let(:attrs) { { readable: true, exists: false } }

      it 'returns the path if readable' do
        expect(opt.validate(file_path)).to eql file_path
      end

      it 'raises an error otherwise' do
        expect_any_instance_of(Pathname).to receive(:readable?).and_return(false)

        expect { opt.validate(file_path) }.to raise_error(OptParseValidator::Error, "'#{file_path}' is not readable")
      end
    end

    context 'when :writable' do
      context 'when the path exists' do
        let(:attrs) { { writable: true } }

        it 'returns the path if writable' do
          expect(opt.validate(file_path)).to eql file_path
        end

        it 'raises an error otherwise' do
          expect_any_instance_of(Pathname).to receive(:writable?).and_return(false)

          expect { opt.validate(file_path) }.to raise_error(OptParseValidator::Error, "'#{file_path}' is not writable")
        end
      end

      context 'when it does not exist' do
        let(:attrs) { { writable: true, exists: false } }

        context 'when the parent directory is writable' do
          let(:file) { File.join(FIXTURES, 'options_file', 'not_there.txt') }

          it 'returns the path' do
            expect(opt.validate(file)).to eql file
          end
        end

        context 'when the parent directory is not writable' do
          let(:file) { File.join(FIXTURES, 'hfjhg', 'yolo.rb') }

          it 'raises an error' do
            expect { opt.validate(file) }.to raise_error(OptParseValidator::Error, "'#{file}' is not writable")
          end
        end
      end
    end
  end
end
