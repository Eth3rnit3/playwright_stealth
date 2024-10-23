# frozen_string_literal: true

require_relative 'ps_logger'

module PlaywrightStealth
  SCRIPTS_PATH = "#{Dir.pwd}/js".freeze
  SCRIPTS = {
    utils: "#{SCRIPTS_PATH}/utils.js",
    chrome_app: "#{SCRIPTS_PATH}/chrome.app.js",
    chrome_csi: "#{SCRIPTS_PATH}/chrome.csi.js",
    chrome_hairline: "#{SCRIPTS_PATH}/chrome.hairline.js",
    chrome_load_times: "#{SCRIPTS_PATH}/chrome.load.times.js",
    chrome_runtime: "#{SCRIPTS_PATH}/chrome.runtime.js",
    generate_magic_arrays: "#{SCRIPTS_PATH}/generate.magic.arrays.js",
    iframe_content_window: "#{SCRIPTS_PATH}/iframe.contentWindow.js",
    media_codecs: "#{SCRIPTS_PATH}/media.codecs.js",
    navigator_hardware_concurrency: "#{SCRIPTS_PATH}/navigator.hardwareConcurrency.js",
    navigator_languages: "#{SCRIPTS_PATH}/navigator.languages.js",
    navigator_permissions: "#{SCRIPTS_PATH}/navigator.permissions.js",
    navigator_platform: "#{SCRIPTS_PATH}/navigator.platform.js",
    navigator_plugins: "#{SCRIPTS_PATH}/navigator.plugins.js",
    navigator_user_agent: "#{SCRIPTS_PATH}/navigator.userAgent.js",
    navigator_vendor: "#{SCRIPTS_PATH}/navigator.vendor.js",
    navigator_webdriver: "#{SCRIPTS_PATH}/navigator.webdriver.js",
    webgl_vendor: "#{SCRIPTS_PATH}/webgl.vendor.js",
    window_outer_dimensions: "#{SCRIPTS_PATH}/window.outerdimensions.js"
  }.freeze

  module Patcher
    def patch(browser_context)
      inject_scripts(browser_context)
    end

    private

    def inject_scripts(browser_context)
      javascript = ''
      javascript = inject_script(javascript, :utils)
      javascript = inject_script(javascript, :generate_magic_arrays)

      javascript = inject_script(javascript, :chrome_app)
      javascript = inject_script(javascript, :chrome_csi)
      javascript = inject_script(javascript, :chrome_load_times)
      javascript = inject_script(javascript, :chrome_runtime)
      javascript = inject_script(javascript, :iframe_content_window)
      javascript = inject_script(javascript, :media_codecs)
      javascript = inject_script(javascript, :navigator_hardware_concurrency)
      javascript = inject_script(javascript, :navigator_languages)
      javascript = inject_script(javascript, :navigator_permissions)
      javascript = inject_script(javascript, :navigator_plugins)
      javascript = inject_script(javascript, :navigator_webdriver)

      javascript = inject_script(javascript, :navigator_user_agent)
      javascript = inject_script(javascript, :webgl_vendor)
      javascript = inject_script(javascript, :window_outer_dimensions)

      javascript = inject_script(javascript, :navigator_platform)
      javascript = inject_script(javascript, :chrome_hairline)

      browser_context.add_init_script(script: javascript)
    end

    def inject_script(javascript, script)
      logger.log("Injecting script: #{script}")

      "#{javascript}\n#{File.read(SCRIPTS[script])};"
    end

    def config
      PlaywrightStealth.config
    end

    def logger
      config.logger
    end

    module_function :patch, :inject_scripts, :inject_script, :logger, :config
  end
end
