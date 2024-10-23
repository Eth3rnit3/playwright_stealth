# frozen_string_literal: true

require 'playwright'
require_relative 'playwright_stealth/version'
require 'playwright_stealth/download'
require 'playwright_stealth/patcher'

module PlaywrightStealth
  class Error < StandardError; end
  # Your code goes here...

  def browser(browser_name = 'chromium', headless: false)
    # PlaywrightStealth::Download.call
    Playwright.create(playwright_cli_executable_path: Download::EXE_PATH) do |playwright|
      playwright.send(browser_name).launch(headless: headless) do |browser|
        context = browser.new_context
        Patcher.patch(context)
        page = context.new_page
        yield([browser, context, page]) if block_given?
      end
    end
  end

  module_function :browser
end

# PlaywrightStealth.browser do |browser, context, page|
#   page.goto('https://tracking.dmk.ovh')
#   puts page.title
#   binding.irb
# end
