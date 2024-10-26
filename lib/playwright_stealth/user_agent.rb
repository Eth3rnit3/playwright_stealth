# frozen_string_literal: true

require 'rbconfig'
require 'securerandom'

module PlaywrightStealth
  class UserAgent
    def self.detect_os
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /darwin/
        version = `sw_vers -productVersion`.strip # Récupère la version de macOS
        "Mac OS X #{version.gsub(".", "_")}"
      when /linux/
        'Linux'
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        'Windows NT 10.0' # On suppose ici une version Windows 10 moderne
      else
        raise "Système d'exploitation inconnu : #{host_os}"
      end
    end

    def self.generate_user_agent(browser: nil)
      os = detect_os
      browser ||= %w[chrome chromium firefox safari edge].sample

      chrome_version  = '129.0.6668.29'
      firefox_version = '92.0'
      safari_version  = '14.1.2'
      edge_version    = '94.0.992.38'

      case os
      when /Windows/
        user_agent = case browser
                     when 'chrome', 'chromium'
                       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{chrome_version} Safari/537.36"
                     when 'firefox'
                       "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:#{firefox_version}) Gecko/20100101 Firefox/#{firefox_version}"
                     when 'edge'
                       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{chrome_version} Safari/537.36 Edg/#{edge_version}"
                     when 'Safari'
                       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{chrome_version} Safari/#{safari_version}"
                     end
      when /Mac OS X/
        user_agent = case browser
                     when 'chrome', 'chromium'
                       "Mozilla/5.0 (Macintosh; Intel #{os}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{chrome_version} Safari/537.36"
                     when 'firefox'
                       "Mozilla/5.0 (Macintosh; Intel #{os}; rv:#{firefox_version}) Gecko/20100101 Firefox/#{firefox_version}"
                     when 'safari'
                       "Mozilla/5.0 (Macintosh; Intel #{os}) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/#{safari_version} Safari/605.1.15"
                     end
      when /Linux/
        linux_arch = `uname -m`.strip # Récupère l'architecture de l'hôte sous Linux
        user_agent = case browser
                     when 'chrome', 'chromium'
                       "Mozilla/5.0 (X11; Linux #{linux_arch}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{chrome_version} Safari/537.36"
                     when 'firefox'
                       "Mozilla/5.0 (X11; Ubuntu; Linux #{linux_arch}; rv:#{firefox_version}) Gecko/20100101 Firefox/#{firefox_version}"
                     end
      end

      user_agent
    end
  end
end
