require 'spec_helper'

describe OptParseValidator::OptFilePath do
  subject(:opt)  { described_class.new(['-f', '--file FILE_PATH'], attrs) }
  let(:attrs)    { {} }
  let(:rwx_file) { File.join(FIXTURES, 'rwx.txt') }
  let(:r_file)   { File.join(FIXTURES, 'r.txt') }

  its(:attrs)    { should eq file: true }

  describe '#validate' do
    context 'when :extensions' do
      let(:attrs) { { extensions: 'txt' } }

      its('allowed_attrs.first') { should eq :extensions }

      context 'when it matches' do
        it 'returns the path' do
          expect(opt.validate(rwx_file)).to eq rwx_file
        end
      end

      context 'when it does no match' do
        it 'raises an error' do
          expect { opt.validate('yolo.aa') }
            .to raise_error(OptParseValidator::Error, "The extension of 'yolo.aa' is not allowed")
        end
      end
    end

    context 'when :executable' do
      let(:attrs) { { executable: true } }

      it 'returns the path if the file is +x' do
        expect(opt.validate(rwx_file)).to eq rwx_file
      end

      it 'raises an error if not ' do
        expect { opt.validate(r_file) }.to raise_error(OptParseValidator::Error, "'#{r_file}' is not executable")
      end
    end

    context 'when :readable' do
      let(:attrs) { { readable: true, exists: false } }

      it 'returns the path if the file is +r' do
        expect(opt.validate(rwx_file)).to eq rwx_file
      end

      it 'raises an error otherwise' do
        file = File.join(FIXTURES, 'yolo.txt')

        expect { opt.validate(file) }.to raise_error(OptParseValidator::Error, "'#{file}' is not readable")
      end
    end

    context 'when :writable' do
      context 'when the path exists' do
        let(:attrs) { { writable: true } }

        it 'returns the path if the path is +x' do
          expect(opt.validate(rwx_file)).to eq rwx_file
        end

        it 'raises an error otherwise' do
          expect_any_instance_of(Pathname).to receive(:writable?).and_return(false)

          expect { opt.validate(r_file) }.to raise_error(OptParseValidator::Error, "'#{r_file}' is not writable")
        end
      end

      context 'when it does not exist' do
        let(:attrs) { { writable: true, exists: false } }

        context 'when the parent directory is +w' do
          let(:file) { File.join(FIXTURES, 'options_file', 'not_there.txt') }

          it 'returns the path' do
            expect(opt.validate(file)).to eq file
          end
        end

        context 'when the parent directory is not +w' do
          let(:file) { File.join(FIXTURES, 'hfjhg', 'yolo.rb') }

          it 'raises an error' do
            expect { opt.validate(file) }.to raise_error(OptParseValidator::Error, "'#{file}' is not writable")
          end
        end
      end
    end
  end
end
