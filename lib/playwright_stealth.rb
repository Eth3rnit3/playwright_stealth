# frozen_string_literal: true

require 'playwright'
require_relative 'playwright_stealth/version'
require_relative 'playwright_stealth/helpers'
require_relative 'playwright_stealth/configuration'
require 'playwright_stealth/installer'
require 'playwright_stealth/user_agent'
require 'playwright_stealth/native_mouse_controller'
require 'playwright_stealth/window_info'

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
      opts[:args] << "--user-agent=#{UserAgent.generate_user_agent(browser: browser_name)}"

      playwright.send(browser_name).launch_persistent_context(data_dir, **opts) do |context|
        page = context.new_page
        page.set_viewport_size(width: 1920, height: 1080)
        yield([context, page]) if block_given?
      end
    end
  end
  module_function :browser, :configure, :config, :install, :installed?, :configuration
end
