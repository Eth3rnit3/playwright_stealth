# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[spec rubocop]

require_relative 'lib/playwright_stealth'
namespace :test do
  desc 'Open a browser and get interactive session'
  task :open_browser do
    PlaywrightStealth.browser(headless: false) do |_context, page|
      binding.irb
    end
  end

  desc 'Run Intoli test in headless mode'
  task :intoli do
    PlaywrightStealth.browser(headless: true) do |_context, page|
      page.goto('https://bot.sannysoft.com')
      # find first table
      page.wait_for_selector('table')
      tables = page.query_selector_all('table')
      sleep(3)
      tables.first.screenshot(path: 'results/intoli.png')
      tables[1].screenshot(path: 'results/intoli2.png')
    end
  end

  desc 'Run Pixelscan test in headless mode'
  task :pixelscan do
    PlaywrightStealth.browser(headless: true) do |_context, page|
      page.goto('https://pixelscan.net')
      page.wait_for_selector('.consistency-container')
      container = page.locator('.consistency-container')
      sleep(5)
      container.screenshot(path: 'results/pixelscan.png')
    end
  end

  desc 'Run Brodetector test in headless mode'
  task :brodetector do
    PlaywrightStealth.browser(headless: true) do |_context, page|
      page.goto('https://kaliiiiiiiiii.github.io/brotector?crash=false')
      page.wait_for_selector('#clickHere')
      element = page.locator('#clickHere')
      element.click
      sleep(5)
      page.screenshot(path: 'results/brodetector.png')
    end
  end

  desc 'Run Browserleaks test in headless mode'
  task :browserleaks do
    PlaywrightStealth.browser(headless: true) do |_context, page|
      page.goto('https://browserleaks.com/canvas')
      page.wait_for_selector('#canvas-data')
      container = page.query_selector('#canvas-data')
      sleep(5)
      container.screenshot(path: 'results/browserleaks.png')
    end
  end

  desc 'Run Chrome Config in browser mode'
  task :chrome_config do
    PlaywrightStealth.browser(headless: false) do |_context, page|
      sleep(1)
      page.goto('chrome://version')
      sleep(2)
      page.screenshot(path: 'results/chrome_config.png')
    end
  end
end
