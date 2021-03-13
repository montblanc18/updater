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
    example 'Run OS check' do
      os_check
    end

    example 'if os is macosx is set' do
      expect(os_check).to eq true if os == :macosx
    end

    example 'if os is linux is set' do
      expect(os_check).to eq true if os == :linux
    end
  end

  describe 'macport functions' do
    it 'test macport_inactive_uninstaller' do
      # expect(self).to receive(:system)
      macport_inactive_uninstaller
    end
    it 'test macport_cleaner' do
      # expect(self).to receive(:system)
      macport_cleaner
    end
    it 'test macport_selfupdater' do
      # expect(self).to receive(:system)
      # expect(self).to receive(:system)
      macport_selfupdater
    end
    it 'test macport_upgrader' do
      expect(self).to receive(:system)
      macport_upgrader
    end
  end
end

RSpec.describe 'TestTimeMachineFunctions' do
  describe 'test listdisplay' do
    it 'test normal case' do
      expect(time_machine_listdiplay).to eq(true)
    end
  end

  describe 'test time_machine_checker' do
    it 'test normal case' do
      expect(time_machine_checker).to eq(true)
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
      expect(rubygem_outdated_cmd(opts_str)).to eq(cmd)
    end

    let(:opts) { {} }

    it 'test rubygme_update_handler' do
      allow($stdin).to receive(:gets).and_return('YES')
      $stdin = StringIO.new('')
      expect(rubygem_update_handler(opts)).to eq(true)
      $stdin = STDIN
    end

    it 'test rubygme_clean_handler' do
      allow($stdin).to receive(:gets).and_return('YES')
      $stdin = StringIO.new('')
      expect(rubygem_clean_handler(opts)).to eq(true)
      $stdin = STDIN
    end
  end

  describe 'rubygem_updater' do
    context 'case) do not get YES' do
      let(:opts) { {} }
      example 'test rubygem_updater when it do not get YES' do
        # stub STDOUT & STDIN
        expect($stdout).to receive(:puts).with('[INFO] Do you want to update all gems?')
        allow($stdin).to receive(:gets).and_return('')
        expect($stdout).to receive(:puts).with('[SKIP] gem update...')
        $stdin = StringIO.new('')
        rubygem_updater(opts, '')
        $stdin = STDIN
      end

      example 'test rubygem_updater with -y option' do
        opts[:not_interactive] = true
        expect(rubygem_updater(opts, '')).to eq(true)
        opts[:not_interactive] = false
      end
    end
    context 'cace) get YES' do
      let(:opts) { {} }
      example 'test rubygem_cleaner when it do not get YES' do
        # stub STDOUT & STDIN
        allow($stdin).to receive(:gets).and_return('YES')
        $stdin = StringIO.new('')
        expect(rubygem_updater(opts, '')).to eq(true)
        $stdin = STDIN
      end
    end
  end

  describe 'rubygem_cleaner yes/no' do
    context 'case) do not get YES' do
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

    context 'when) get YES' do
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

  describe 'rubygem_opts_builder' do
    let(:opts) { {} }
    it 'test rubygem_opts_builder' do
      opts_str = ''
      expect(rubygem_opts_builder(opts)).to eq(opts_str)
    end

    it 'test rubygem_opts_builder w/ verbose option' do
      opts[:rubygem_option] = true
      opts_str = ' --verbose'
      expect(rubygem_opts_builder(opts)).to eq(opts_str)
      opts[:rubygem_option] = false
    end

    it 'test rubygem_opts_builder w/ proxy option' do
      opts[:proxy] = true
      opts[:proxy_params] = {}
      opts[:proxy_params][:url] = 'test@example.com'
      opts_str = " --remote --http-proxy=#{opts[:proxy_params][:url]}"
      expect(rubygem_opts_builder(opts)).to eq(opts_str)
      opts[:proxy] = false
    end
  end
end

RSpec.describe 'TestMainHndler' do
  describe 'main handler' do
    let(:opts) { {} }
    it 'test main handler' do
      main_handler(opts)
    end
  end
end

# rubocop:enable Metrics/BlockLength
