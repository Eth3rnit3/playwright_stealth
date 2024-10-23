# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PlaywrightStealth::Installer do
  let(:installer) { described_class }

  before { allow(Net::HTTP).to receive(:get).and_return('zip_data') }

  describe '#install' do
    before do
      allow(installer).to receive(:remove_driver).and_return(nil)
      allow(installer).to receive(:write_file).and_return(nil)
      allow(installer).to receive(:unzip_driver).and_return(nil)
      allow(installer).to receive(:make_executable).and_return(nil)
      allow(installer).to receive(:install_dependencies).and_return(nil)
    end

    it 'calls all the necessary methods' do
      installer.install

      expect(installer).to have_received(:remove_driver)
      expect(installer).to have_received(:write_file)
      expect(installer).to have_received(:unzip_driver)
      expect(installer).to have_received(:make_executable)
      expect(installer).to have_received(:install_dependencies)
    end
  end

  describe '#remove_driver' do
    context 'when the driver directory exists' do
      before do
        allow(File).to receive(:directory?).and_return(true)
        allow(FileUtils).to receive(:rm_rf)
      end

      it 'removes the driver directory' do
        installer.send(:remove_driver)

        expect(FileUtils).to have_received(:rm_rf)
      end
    end

    context 'when the driver directory does not exist' do
      before do
        allow(File).to receive(:directory?).and_return(false)
        allow(FileUtils).to receive(:rm_rf)
      end

      it 'does not remove the driver directory' do
        installer.send(:remove_driver)

        expect(FileUtils).not_to have_received(:rm_rf)
      end
    end
  end

  describe '#download_driver' do
    it 'downloads the driver' do
      expect(installer.send(:download_driver)).to eq('zip_data')
    end
  end

  describe '#write_file' do
    before do
      allow(File).to receive(:binwrite)
    end

    it 'writes the file' do
      installer.send(:write_file, 'zip_data')

      expect(File).to have_received(:binwrite)
    end
  end

  describe '#unzip_driver' do
    before do
      allow(FileUtils).to receive(:mkdir_p)
      allow(File).to receive(:directory?).and_return(false)
      allow(Zip::File).to receive(:open)
    end

    it 'unzips the driver' do
      installer.send(:unzip_driver)

      expect(FileUtils).to have_received(:mkdir_p)
      expect(Zip::File).to have_received(:open)
    end
  end

  describe '#make_executable' do
    before do
      allow(FileUtils).to receive(:chmod)
    end

    it 'makes the driver executable' do
      installer.send(:make_executable)

      expect(FileUtils).to have_received(:chmod).with('+x', described_class.config.exe_path)
    end
  end
end
