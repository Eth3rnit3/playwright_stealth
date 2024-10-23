# frozen_string_literal: true

require 'net/http'
require 'zip'
require_relative 'ps_logger'

module PlaywrightStealth
  module Installer
    def install
      remove_driver
      write_file(download_driver)
      unzip_driver
      make_executable
      install_dependencies
      logger.log('Playwright driver downloaded and unzipped')
    end

    private

    def remove_driver
      return unless File.directory?(config.driver_path)

      logger.log("Removing current Playwright driver from #{config.driver_path}")
      FileUtils.rm_rf(config.driver_path)
    end

    def download_driver
      logger.log('Downloading Playwright driver...')
      uri = URI(config.playwright_url)
      Net::HTTP.get(uri)
    rescue StandardError => e
      raise DownloadError, "Failed to download chromedriver zip: #{e.message}"
    end

    def write_file(data)
      output_path = '/tmp/playwright.zip'
      logger.log("Writing Playwright driver to #{output_path}")
      File.binwrite(output_path, data)
      output_path
    rescue StandardError => e
      raise WriteError, "Failed to write chromedriver zip: #{e.message}"
    end

    def unzip_driver
      logger.log("Unzipping Playwright driver to #{config.driver_path}")
      FileUtils.mkdir_p(config.driver_path) unless File.directory?(config.driver_path)

      Zip::File.open(config.zip_path) do |zip_file|
        zip_file.each do |f|
          zip_file.extract(f, "#{config.driver_path}/#{f.name}")
        end
      end
    end

    def make_executable
      logger.log('Making Playwright driver executable')

      FileUtils.chmod('+x', config.exe_path)
    end

    def install_dependencies
      logger.log('Installing Playwright dependencies')

      system("#{config.exe_path} install")
    end

    def config
      PlaywrightStealth.config
    end

    def logger
      config.logger
    end

    module_function :install, :download_driver, :write_file, :unzip_driver, :remove_driver, :make_executable, :install_dependencies, :config, :logger
  end
end
