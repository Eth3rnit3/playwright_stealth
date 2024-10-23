# frozen_string_literal: true

require 'playwright'
require_relative 'playwright_stealth/version'
require_relative 'playwright_stealth/helpers'
require_relative 'playwright_stealth/configuration'
require 'playwright_stealth/installer'
require 'playwright_stealth/patcher'

module PlaywrightStealth
  include Helpers

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

  def browser(browser_name = 'chromium', headless: true)
    Playwright.create(playwright_cli_executable_path: config.exe_path) do |playwright|
      data_dir = "#{Dir.home}/playwright-profile"
      opts = {
        headless: headless,
        args: config.args,
        ignoreDefaultArgs: [
          '--enable-automation',
          '--disable-extensions',
          '--disable-background-networking',
          '--disable-background-timer-throttling',
          '--disable-renderer-backgrounding',
          '--disable-dev-shm-usage',
          '--metrics-recording-only',
          '--use-mock-keychain'
        ]
      }
      opts[:args] = config.args + config.headless_args if headless
      playwright.send(browser_name).launch_persistent_context(data_dir, **opts) do |context|
        Patcher.patch(context)
        page = context.new_page
        yield([context, page]) if block_given?
      end
    end
  end
  module_function :browser, :configure, :config, :install, :installed?, :configuration, :valid_agent
end
