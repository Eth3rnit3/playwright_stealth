# frozen_string_literal: true

require_relative 'ps_logger'

module PlaywrightStealth
  class Configuration
    URL         = 'https://playwright.azureedge.net/builds/driver/playwright-1.45.0-linux.zip' # latest undetectable version https://github.com/kaliiiiiiiiii/brotector?tab=readme-ov-file#pwinitscript
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
