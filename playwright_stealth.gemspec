# frozen_string_literal: true

require_relative 'lib/playwright_stealth/version'

Gem::Specification.new do |spec|
  spec.name = 'playwright_stealth'
  spec.version = PlaywrightStealth::VERSION
  spec.authors = ['Eth3rnit3']
  spec.email = ['eth3rnit3@gmail.com']

  spec.summary = 'Playwright Stealth is a Ruby gem that allows you to use Playwright with stealth mode.'
  spec.description = 'Playwright Stealth is a Ruby gem that allows you to use Playwright with stealth mode. It patches Playwright to prevent detection.'
  spec.homepage = 'https://github.com/Eth3rnit3/playwright_stealth'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/Eth3rnit3'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Eth3rnit3/playwright_stealth'
  spec.metadata['changelog_uri'] = 'https://github.com/Eth3rnit3/playwright_stealth/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 7.2'
  spec.add_dependency 'playwright-ruby-client', '~> 1.47'
  spec.add_dependency 'rubyzip', '~> 2.3'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
