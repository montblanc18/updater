#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mupdater'

RSpec.describe 'TestMupdater' do
  describe 'os_check' do
    example 'if os is macosx is set' do
      expect(os_check).to eq true if os == :macosx
    end

    example 'if os is linux is set' do
      expect(os_check).to eq true if os == :linux
    end
  end

  describe 'macport functions' do
    it 'test macport_inactive_uninstaller' do
      expect(self).to receive(:system)
      macport_inactive_uninstaller
    end
    it 'test macport_cleaner' do
      expect(self).to receive(:system)
      macport_cleaner
    end
    it 'test macport_selfupdater' do
      expect(self).to receive(:system)
      expect(self).to receive(:system)
      macport_selfupdater
    end
    it 'test macport_upgrader' do
      expect(self).to receive(:system)
      macport_upgrader
    end
  end

  describe 'rubygem functions' do
    it 'test rubygem_updater_cmd' do
      opts_str = ' options'
      cmd = format('gem update --system%<opts>s', opts: opts_str)
      expect(rubygem_updater_cmd(opts_str)).to eq(cmd)
    end
    it 'test rubygem_outdated_cmd' do
      opts_str = ' options'
      cmd = format('gem outdated%<opts>s', opts: opts_str)
      expect(rubygem_outdated_cmd(opts_str)).to eq(cmd)
    end
  end
end
