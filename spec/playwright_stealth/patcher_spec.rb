# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PlaywrightStealth::Patcher do
  let(:patcher) { described_class }
  let(:browser_context) { instance_double(Playwright::BrowserContext) }

  before do
    allow(browser_context).to receive(:add_init_script)
  end

  describe '#patch' do
    before { allow(patcher).to receive(:inject_scripts) }

    it 'calls #inject_scripts' do
      patcher.patch(browser_context)

      expect(patcher).to have_received(:inject_scripts).with(browser_context)
    end
  end

  describe '#inject_scripts' do
    let(:javascript) { '' }

    before { allow(patcher).to receive(:inject_script).and_return(javascript) }

    it 'calls #inject_script' do
      patcher.inject_scripts(browser_context)

      expect(patcher).to have_received(:inject_script).exactly(18).times
    end

    it 'calls #add_init_script' do
      patcher.inject_scripts(browser_context)

      expect(browser_context).to have_received(:add_init_script).with(script: javascript)
    end
  end

  describe '#inject_script' do
    let(:javascript) { '' }
    let(:script) { :utils }

    it 'returns a string' do
      expect(patcher.inject_script(javascript, script)).to be_a(String)
    end

    it 'returns a string with the script injected' do
      expect(patcher.inject_script(javascript, script)).to include('utils')
    end
  end
end
