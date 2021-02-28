#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mupdater_function'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'TestMupdaterFunction' do
  describe 'logout_process()' do
    it 'test an output of logout_message.' do
      t_msg = ["=========================\n",
               "=                       =\n",
               "===  finish mupdater  ===\n",
               "=                       =\n",
               "=========================\n"].join
      expect { logout_message }.to output(eq(t_msg)).to_stdout
    end

    it 'confirm the behavor of "exit" via logout_process.' do
      expect { logout_process }.to raise_error SystemExit
    end
  end

  describe 'start_message()' do
    it 'confirm output.' do
      t_msg = ["=========================\n",
               "=                       =\n",
               "===  start mupdater   ===\n",
               "=                       =\n",
               "=========================\n"].join
      expect { start_message }.to output(eq(t_msg)).to_stdout
    end
  end

  describe 'skip_message(message)' do
    it 'test an output of skip_message' do
      msg = 'This is Test Message'
      head = '[SKIP] '
      foot = "...\n"
      t_msg = [head, msg, foot].join
      expect { skip_message(msg) }.to output(eq(t_msg)).to_stdout
    end
  end

  describe 'do_cmd(cmd)' do
    it 'test an behavour of do_cmd via echo command' do
      msg = 'This is sample message for this test.'
      cmd = format("echo '%s'", msg)
      t_msg = ['[CMD] ', cmd, "\n"].join
      expect(self).to receive(:system)
      print('sss')
      expect { do_cmd(cmd) }.to output(eq(t_msg)).to_stdout
    end

    it 'test with mock' do
      msg = 'This is test.'
      cmd = format("echo '%s'", msg)
      # t_msg = ['[CMD] ', cmd, "\n"].join
      expect(self).to receive(:system)
      do_cmd(cmd)
    end
  end

  describe 'notice(message)' do
    it 'test an output of notice' do
      msg = 'This is Test Message'
      head = '[INFO] '
      foot = "\n"
      t_msg = [head, msg, foot].join
      expect { notice(msg) }.to output(eq(t_msg)).to_stdout
    end
  end

  describe 'waring(message)' do
    it 'test an output of warning' do
      msg = 'This is Test Message'
      head = '[WARN] '
      foot = "\n"
      t_msg = [head, msg, foot].join
      expect { warning(msg) }.to output(eq(t_msg)).to_stdout
    end
  end

  describe 'error(message)' do
    it 'test an output of error' do
      msg = 'This is Test Message'
      head = '[ERR] '
      foot = "\n"
      t_msg = [head, msg, foot].join
      expect { error(msg) }.to output(eq(t_msg)).to_stdout
    end
  end

  describe 'yn_input_waiting(not_interactive = false)' do
    context 'when) return = true' do
      example 'if "not_interactice = true" is set ' do
        expect(yn_input_waiting(true)).to eq(true)
      end

      specify 'confirm an output if "not_interactice = true" is set ' do
        msg = '[YES/no]: YES'
        head = ''
        foot = "\n"
        t_msg = [head, msg, foot].join
        expect { yn_input_waiting(true) }.to output(eq(t_msg)).to_stdout
      end
    end
  end

  describe 'print_message' do
    it 'test desplay message' do
      msg = 'describe msg'
      num = msg.size
      l = ''
      (0..num - 1 + 6).each do |_i|
        l += '*'
      end
      t_msg = [l, "\n", format('*  %<message>s  *', message: msg), "\n", l, "\n"].join
      expect { print_message(msg) }.to output(eq(t_msg)).to_stdout
    end
  end

  describe 'os function' do
    os_back = RbConfig::CONFIG['host_os']
    it 'when) mswin' do
      RbConfig::CONFIG['host_os'] = 'mswin'
      expect(os).to eq(:windows)
    end
    it 'when) msys' do
      RbConfig::CONFIG['host_os'] = 'msys'
      expect(os).to eq(:windows)
    end
    it 'when) mingw' do
      RbConfig::CONFIG['host_os'] = 'mingw'
      expect(os).to eq(:windows)
    end
    it 'when) cygwin' do
      RbConfig::CONFIG['host_os'] = 'cygwin'
      expect(os).to eq(:windows)
    end
    it 'when) bccwin' do
      RbConfig::CONFIG['host_os'] = 'bccwin'
      expect(os).to eq(:windows)
    end
    it 'when) wince' do
      RbConfig::CONFIG['host_os'] = 'wince'
      expect(os).to eq(:windows)
    end
    it 'when) emc' do
      RbConfig::CONFIG['host_os'] = 'emc'
      expect(os).to eq(:windows)
    end
    it 'when) macosx' do
      RbConfig::CONFIG['host_os'] = 'mac os'
      expect(os).to eq(:macosx)
    end
    it 'when) darwin' do
      RbConfig::CONFIG['host_os'] = 'darwin'
      expect(os).to eq(:macosx)
    end
    it 'when) linux' do
      RbConfig::CONFIG['host_os'] = 'linux'
      expect(os).to eq(:linux)
    end
    it 'when) solaris' do
      RbConfig::CONFIG['host_os'] = 'solaris'
      expect(os).to eq(:unix)
    end
    it 'when) bsd' do
      RbConfig::CONFIG['host_os'] = 'bsd'
      expect(os).to eq(:unix)
    end
    it 'when) unkown' do
      RbConfig::CONFIG['host_os'] = 'unkown'
      expect(os).to eq(:unknown)
    end
    RbConfig::CONFIG['host_os'] = os_back
  end
end
# rubocop:enable Metrics/BlockLength:
