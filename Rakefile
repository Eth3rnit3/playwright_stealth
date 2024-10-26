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

  desc 'Open a browser and get interactive session (headless)'
  task :open_browser_headless do
    PlaywrightStealth.browser(headless: true) do |_context, page|
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
      box = element.bounding_box
      controller = PlaywrightStealth::NativeMouseController.new
      binding.irb
      controller.set_focus
      controller.move_and_click(box)
      controller.move_and_click(box)
      controller.move_and_click(box)
      page.screenshot(path: 'results/brodetector.png')
      controller.close
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

  # bundle exec rake test:bot_detector
  desc 'Run Bot Detector test in headless mode'
  task :bot_detector do
    PlaywrightStealth.browser(headless: true) do |_context, page|
      page.goto('https://bot-detector.rebrowser.net')
      page.wait_for_selector('#detections-table')
      table = page.query_selector('#detections-table')
      sleep(5)
      table.screenshot(path: 'results/bot-detector.png')
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

  task :native_click do
    PlaywrightStealth.browser(headless: false) do |_context, page|
      page.goto('http://127.0.0.1:8001')

      # Init mouse controller
      controller = PlaywrightStealth::NativeMouseController.new
      controller.set_focus
      element = page.locator('#interactive-button')
      bounding_box = element.bounding_box
      controller.move_and_click(bounding_box)
      page.screenshot(path: 'tests/whereIClick/click.png')

      controller.close
    end
  end

  task :native_click_each_pixel do
    PlaywrightStealth.browser(headless: false) do |_context, page|
      page.goto('http://127.0.0.1:8001')

      min_x = 10
      max_x = 1920
      min_y = 100
      max_y = 1080
      controller = PlaywrightStealth::NativeMouseController.new
      controller.set_focus
      (min_x..max_x).each do |x|
        (min_y..max_y).each do |y|
          # click every 30 pixels
          next if x % 30 != 0 || y % 30 != 0
          next if y >= 500

          puts "Clicking on x: #{x} y: #{y}"
          controller.move_mouse(x, y)
          controller.click
          page.screenshot(path: 'tests/whereIClick/click.png')
        end
      end

      controller.close
    end
  end

  task :native_click_on_corners do
    PlaywrightStealth.browser(headless: false) do |_context, page|
        # Exemple d'utilisation :
      info = PlaywrightStealth::WindowInfo.new
      root_win = info.root_window
      puts 'Root window geometry:'
      puts info.window_geometry(root_win)
      page.goto('http://127.0.0.1:8001')

      view_port = page.viewport_size

      min_x = 10
      max_x = view_port[:width] + 20
      min_y = 100
      max_y = view_port[:height] + 200
      
      controller = PlaywrightStealth::NativeMouseController.new
      controller.set_focus

      # Click on top left corner
      controller.move_mouse(min_x, min_y)
      controller.click
      page.screenshot(path: 'tests/whereIClick/click.png')

      # Click on top right corner
      controller.move_mouse(max_x, min_y)
      controller.click
      page.screenshot(path: 'tests/whereIClick/click.png')

      # Click on bottom left corner
      controller.move_mouse(min_x, max_y)
      controller.click
      page.screenshot(path: 'tests/whereIClick/click.png')

      # Click on bottom right corner
      controller.move_mouse(max_x, max_y)
      controller.click
      page.screenshot(path: 'tests/whereIClick/click.png')

      # Click on center
      controller.move_mouse(max_x / 2, max_y / 2)
      controller.click
      page.screenshot(path: 'tests/whereIClick/click.png')

      controller.close
    end
  end
end