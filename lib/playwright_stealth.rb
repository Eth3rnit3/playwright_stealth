# frozen_string_literal: true

require 'playwright'
require_relative 'playwright_stealth/version'
require_relative 'playwright_stealth/configuration'
require 'playwright_stealth/installer'
require 'playwright_stealth/patcher'

module PlaywrightStealth
  class Error < StandardError; end

  def configuration
    @configuration ||= Configuration.new
  end

  def config
    configuration.config
  end

  def configure
    yield(config)
  end

  def install
    Installer.install
  end

  def installed?
    File.exist?(config.exe_path)
  end

  def browser(browser_name = 'chromium', headless: false)
    Playwright.create(playwright_cli_executable_path: config.exe_path) do |playwright|
      playwright.send(browser_name).launch_persistent_context("#{Dir.home}/playwright-profile", headless: headless) do |context|
        Patcher.patch(context)
        page = context.new_page
        yield([nil, context, page]) if block_given?
      end
    end
  end
  module_function :browser, :configure, :config, :install, :installed?, :configuration

  # Obfuscation tests

  def test_intoli
    PlaywrightStealth.browser do |browser, context, page|
      page.goto('https://bot.sannysoft.com')
      sleep(5)
      page.screenshot(path: 'results/intoli.png')
    end
  end

  def test_pixelscan
    PlaywrightStealth.browser do |browser, context, page|
      page.goto('https://pixelscan.net/')
      sleep(10)
      page.screenshot(path: 'results/pixelscan.png')
    end
  end

  module_function :test_intoli, :test_pixelscan
end
