# frozen_string_literal: true

require_relative 'ps_logger'

module PlaywrightStealth
  class Configuration
    URL         = 'https://playwright.azureedge.net/builds/driver/playwright-1.47.2-linux.zip' # https://github.com/rebrowser/rebrowser-patches?tab=readme-ov-file#playwright-support
    ZIP_PATH    = '/tmp/playwright.zip'
    DRIVER_DIR  = "#{Dir.pwd}/playwright".freeze
    EXE_PATH    = "#{DRIVER_DIR}/package/cli.js".freeze

    attr_accessor :playwright_url, :zip_path, :driver_path, :exe_path, :logger, :headless, :args, :headless_args

    def initialize
      @playwright_url = URL
      @zip_path       = ZIP_PATH
      @driver_path    = DRIVER_DIR
      @exe_path       = EXE_PATH
      @logger         = PsLogger
      @headless       = false
      @args           = [
        '--no-first-run',
        '--start-maximized',
        '--lang=en-EN',
        '--disable-blink-features=AutomationControlled'
      ]
      @headless_args = [
        '--window-size=1920,1080',
        '--window-position=-2400,-2400',
        '--headless=new'
      ]
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield(config)
    end

    def config
      self.class.config
    end
  end
end
