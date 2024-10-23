# frozen_string_literal: true

require 'active_support'
require_relative 'ps_logger'

module PlaywrightStealth
  class Configuration
    include ActiveSupport::Configurable

    URL         = 'https://playwright.azureedge.net/builds/driver/playwright-1.47.1-linux.zip'
    ZIP_PATH    = '/tmp/playwright.zip'
    DRIVER_DIR  = "#{Dir.pwd}/playwright".freeze
    EXE_PATH    = "#{DRIVER_DIR}/package/cli.js".freeze

    configure do |config|
      config.playwright_url = URL
      config.zip_path       = ZIP_PATH
      config.driver_path    = DRIVER_DIR
      config.exe_path       = EXE_PATH
      config.logger         = PsLogger
      config.headless       = false
      config.args           = [
        '--no-first-run',
        '--start-maximized',
        '--no-sandbox',
        '--lang=en-EN',
        '--disable-blink-features=AutomationControlled',
        '--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko)'
      ]
      config.headless_args = [
        '--window-position=-2400,-2400',
        '--headless=new'
      ]
    end
  end
end
