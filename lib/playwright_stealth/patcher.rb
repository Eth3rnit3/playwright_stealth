# frozen_string_literal: true

require_relative 'ps_logger'

module PlaywrightStealth
  SCRIPTS_PATH = "#{Dir.pwd}/js".freeze
  SCRIPTS = {
    utils: "#{SCRIPTS_PATH}/utils.js",
    chrome_app: "#{SCRIPTS_PATH}/chrome.app.js"
  }.freeze

  module Patcher
    def patch(browser_context)
      patch_navigator(browser_context)
      inject_scripts(browser_context)
    end

    private

    def patch_navigator(browser_context)
      PsLogger.log('Patching navigator.webdriver')
      browser_context.add_init_script(script: "Object.defineProperty(navigator, 'webdriver', { get: () => undefined })")
    end

    def inject_scripts(browser_context)
      SCRIPTS.each_value do |path|
        inject_script(browser_context, path)
      end
    end

    def inject_script(browser_context, script)
      PsLogger.log("Injecting script: #{File.basename(script)}")

      browser_context.add_init_script(path: script)
    end

    module_function :patch, :patch_navigator, :inject_scripts, :inject_script
  end
end
