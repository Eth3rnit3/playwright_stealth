# frozen_string_literal: true

require_relative 'ps_logger'

module PlaywrightStealth
  module Setup
    def setup
      # TODO
      # - Dowload playwright driver and unzip it (https://playwright.azureedge.net/builds/driver/playwright-1.47.1-linux.zip)
      # - Add the path to the driver to the PATH
      # - Setting up playwright-ruby-client to use the driver
      # - Add initialization js scripts (https://playwright-ruby-client.vercel.app/docs/api/browser)
    end
    module_function :setup
  end
end
