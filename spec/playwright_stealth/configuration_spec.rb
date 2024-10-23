# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PlaywrightStealth::Configuration do
  describe 'default values' do
    it 'has default values' do
      expect(described_class.config.playwright_url).to eq(described_class::URL)
      expect(described_class.config.zip_path).to eq(described_class::ZIP_PATH)
      expect(described_class.config.driver_path).to eq(described_class::DRIVER_DIR)
      expect(described_class.config.exe_path).to eq(described_class::EXE_PATH)
      expect(described_class.config.logger).to eq(PlaywrightStealth::PsLogger)
      expect(described_class.config.headless).to eq(false)
      expect(described_class.config.args).to be_kind_of(Array)
      expect(described_class.config.headless_args).to be_kind_of(Array)
    end
  end

  describe 'configure' do
    it 'yields self' do
      described_class.configure do |config|
        expect(config).to eq(described_class.config)
      end
    end
  end
end
