# frozen_string_literal: true

require 'net/http'
require 'zip'
require_relative 'ps_logger'

module PlaywrightStealth
  module Download
    URL         = 'https://playwright.azureedge.net/builds/driver/playwright-1.47.1-linux.zip'
    ZIP_PATH    = '/tmp/playwright.zip'
    DRIVER_DIR  = "#{Dir.pwd}/playwright".freeze
    EXE_PATH    = "#{DRIVER_DIR}/package/cli.js".freeze

    def call
      remove_driver
      write_file(download_driver)
      unzip_driver
      make_executable
      install_dependencies
      PsLogger.log('Playwright driver downloaded and unzipped')
    end

    private

    def remove_driver
      return unless File.directory?(DRIVER_DIR)

      PsLogger.log("Removing current Playwright driver from #{DRIVER_DIR}")
      FileUtils.rm_rf(DRIVER_DIR)
    end

    def download_driver
      PsLogger.log('Downloading Playwright driver...')
      uri = URI(URL)
      Net::HTTP.get(uri)
    rescue StandardError => e
      raise DownloadError, "Failed to download chromedriver zip: #{e.message}"
    end

    def write_file(data)
      output_path = '/tmp/playwright.zip'
      PsLogger.log("Writing Playwright driver to #{output_path}")
      File.binwrite(output_path, data)
      output_path
    rescue StandardError => e
      raise WriteError, "Failed to write chromedriver zip: #{e.message}"
    end

    def unzip_driver
      PsLogger.log("Unzipping Playwright driver to #{DRIVER_DIR}")
      FileUtils.mkdir_p(DRIVER_DIR) unless File.directory?(DRIVER_DIR)

      Zip::File.open(ZIP_PATH) do |zip_file|
        zip_file.each do |f|
          zip_file.extract(f, "#{DRIVER_DIR}/#{f.name}")
        end
      end
    end

    def make_executable
      PsLogger.log('Making Playwright driver executable')

      FileUtils.chmod('+x', EXE_PATH)
    end

    def install_dependencies
      PsLogger.log('Installing Playwright dependencies')

      system("#{EXE_PATH} install")
    end

    module_function :call, :download_driver, :write_file, :unzip_driver, :remove_driver, :make_executable, :install_dependencies
  end
end
