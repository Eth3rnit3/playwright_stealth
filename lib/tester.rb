# frozen_string_literal: true

require_relative 'playwright_stealth'

class Tester
  def initialize(headless: true)
    @headless = headless
  end

  # Tester.new(headless: true).open
  def open
    PlaywrightStealth.browser(headless: @headless) do |_context, page|
      binding.irb # rubocop:disable Lint/Debugger
    end
  end

  # Tester.new(headless: true).test_intoli
  def test_intoli
    PlaywrightStealth.browser(headless: @headless) do |_context, page|
      page.goto('https://bot.sannysoft.com')
      sleep(5)
      page.screenshot(path: 'results/intoli.png')
    end
  end

  # Tester.new(headless: true).test_pixelscan
  def test_pixelscan
    PlaywrightStealth.browser(headless: @headless) do |_context, page|
      page.goto('https://pixelscan.net')
      sleep(5)
      page.screenshot(path: 'results/pixelscan.png')
    end
  end

  # Tester.new(headless: true).test_brodetector
  def test_brodetector
    PlaywrightStealth.browser(headless: @headless) do |_context, page|
      page.goto('https://kaliiiiiiiiii.github.io/brotector')
      page.wait_for_selector('#clickHere')
      page.click('#clickHere')
      sleep(5)
      page.screenshot(path: 'results/brodetector.png')
    end
  end

  # Tester.new(headless: true).test_browserleaks
  def test_browserleaks
    PlaywrightStealth.browser(headless: @headless) do |_context, page|
      page.goto('https://browserleaks.com/canvas')
      sleep(5)
      page.screenshot(path: 'results/browserleaks.png')
    end
  end

  # Tester.new(headless: true).test_chrome_config
  def test_chrome_config
    PlaywrightStealth.browser(headless: @headless) do |_context, page|
      sleep(1)
      page.goto('chrome://version')
      sleep(2)
      page.screenshot(path: 'results/chrome_config.png')
    end
  end
end
