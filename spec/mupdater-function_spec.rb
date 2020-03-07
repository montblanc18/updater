# coding: utf-8

require 'mupdater-function'

RSpec.describe 'test of mupdater-function' do 

  describe 'logout_process()' do
    it 'test an output of logout_message.' do
      t_msg = ["=========================\n",
               "=                       =\n",
               "===  finish mupdater  ===\n",
               "=                       =\n",
               "=========================\n"].join
      expect {logout_message }.to output(eq(t_msg)).to_stdout
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
      expect { start_message() }.to output(eq(t_msg)).to_stdout
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
      cmd = "echo '" + msg + "'"
      t_msg = cmd + "\n" #+ msg + "\n"
      expect { do_cmd(cmd) }.to output(eq(t_msg)).to_stdout
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

  describe 'Waring(message)' do
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
    context 'case) return = true' do
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
end
