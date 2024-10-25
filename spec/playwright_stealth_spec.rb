# frozen_string_literal: true

RSpec.describe PlaywrightStealth do
  it 'has a version number' do
    expect(PlaywrightStealth::VERSION).not_to be nil
  end

  describe '#configuration' do
    it 'returns a Configuration object' do
      expect(PlaywrightStealth.configuration).to be_a(PlaywrightStealth::Configuration)
    end
  end

  describe '#config' do
    it 'returns a hash' do
      expect(PlaywrightStealth.config).to be_a(PlaywrightStealth::Configuration)
    end
  end

  describe '#configure' do
    it 'yields to a block' do
      expect { |b| PlaywrightStealth.configure(&b) }.to yield_control
    end
  end

  describe '#install' do
    it 'calls Installer.install' do
      allow(PlaywrightStealth::Installer).to receive(:install)

      PlaywrightStealth.install

      expect(PlaywrightStealth::Installer).to have_received(:install)
    end
  end

  describe '#installed?' do
    context 'when the executable exists' do
      it 'returns true' do
        allow(File).to receive(:exist?).and_return(true)

        expect(PlaywrightStealth.installed?).to be(true)
      end
    end

    context 'when the executable does not exist' do
      it 'returns false' do
        allow(File).to receive(:exist?).and_return(false)

        expect(PlaywrightStealth.installed?).to be(false)
      end
    end
  end

  describe '#browser' do
    let(:browser_name) { 'chromium' }
    let(:headless) { true }
    let(:playwright) { instance_double(Playwright::Playwright) }
    let(:browser) { instance_double(Playwright::BrowserType) }
    let(:context) { instance_double(Playwright::BrowserContext) }
    let(:page) { instance_double(Playwright::Page) }

    before do
      allow(Playwright).to receive(:create).and_yield(playwright)
      allow(playwright).to receive(:chromium).and_return(browser)
      allow(browser).to receive(:launch_persistent_context).and_yield(context)
      allow(context).to receive(:new_page).and_return(page)
      allow(PlaywrightStealth::Patcher).to receive(:patch)
    end

    it 'calls Playwright.create' do
      PlaywrightStealth.browser(browser_name, headless: headless)

      expect(Playwright).to have_received(:create)
    end

    it 'calls Patcher.patch' do
      PlaywrightStealth.browser(browser_name, headless: headless)

      expect(PlaywrightStealth::Patcher).to have_received(:patch).with(context)
    end

    it 'calls Browser#new_page' do
      PlaywrightStealth.browser(browser_name, headless: headless)

      expect(context).to have_received(:new_page)
    end

    it 'yields to a block' do
      expect { |b| PlaywrightStealth.browser(browser_name, headless: headless, &b) }.to yield_with_args([context, page])
    end
  end
end
