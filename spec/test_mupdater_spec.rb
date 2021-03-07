#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mupdater'

module Kernel
  def system(cmd)
    puts format("Mock System Call = '%{command}s'", command: cmd)
  end
end

# rubocop:disable Metrics/BlockLength
RSpec.describe 'TestMupdaterFunctions' do
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
end

RSpec.describe 'TestRubygemFunctions' do
  describe 'rubygem functions' do
    it 'test rubygem_updater_cmd' do
      opts_str = ' options'
      cmd = format('gem update --system%<opts>s', opts: opts_str)
      expect(rubygem_updater_cmd(opts_str)).to eq(cmd)
    end
    it 'test rubygem_outdated_cmd' do
      opts = {}
      opts_str = ' options'
      cmd = format('gem outdated%<opts>s', opts: opts_str)
      expect(rubygem_outdated_cmd(opts, opts_str)).to eq(cmd)
    end
  end
  describe 'rubygem_cleaner yes/no' do
    context 'cace) do not get YES' do
      let(:opts) { {} }
      example 'test rubygem_cleaner when it do not get YES' do
        # stub STDOUT & STDIN
        expect($stdout).to receive(:puts).with('[INFO] Do you want to clean up gems?')
        allow($stdin).to receive(:gets).and_return('')
        expect($stdout).to receive(:puts).with('[SKIP] gem cleanup...')
        $stdin = StringIO.new('')
        rubygem_cleaner(opts)
        $stdin = STDIN
      end

      example 'test rubygem_cleaner with -y option' do
        opts[:not_interactive] = true
        rubygem_cleaner(opts)
        opts[:not_interactive] = false
      end
    end
    context 'cace) do not get YES' do
      let(:opts) { {} }
      example 'test rubygem_cleaner when it do not get YES' do
        # stub STDOUT & STDIN
        allow($stdin).to receive(:gets).and_return('YES')
        $stdin = StringIO.new('')
        rubygem_cleaner(opts)
        $stdin = STDIN
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
