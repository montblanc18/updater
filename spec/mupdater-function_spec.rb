# coding: utf-8

require 'mupdater-function'

RSpec.describe 'mupdater-function' do 
  
  describe 'LogoutProcess()' do

    it 'test an output of LogoutMessage.' do
      t_msg = ["=========================\n",
	       "=                       =\n",
               "===  finish mupdater  ===\n",
               "=                       =\n",
               "=========================\n"].join
      expect {LogoutMessage() }.to output(eq(t_msg)).to_stdout
    end	
    
    it 'confirm the behavor of "exit" via LogoutProcess.' do
      expect { LogoutProcess() }.to raise_error SystemExit
    end

  end
  

  describe 'StartMessage()' do

    it 'confirm output.' do
      t_msg = ["=========================\n",
               "=                       =\n",
               "===  start mupdater   ===\n",
               "=                       =\n",
               "=========================\n"].join
      expect { StartMessage() }.to output(eq(t_msg)).to_stdout
    end

  end

  
  describe 'SkipMessage(message)' do

    it 'test an output of SkipMessage' do
      msg = "This is Test Message"
      head = "[SKIP] "
      foot = "...\n"
      t_msg = [head, msg, foot].join
      expect { SkipMessage(msg) }.to output(eq(t_msg)).to_stdout
    end

  end

  
  describe 'DoCmd(cmd)' do

    it 'test an behavour of DoCmd via echo command' do
      msg = "This is sample message for this test."
      cmd = "echo '" + msg + "'"
      t_msg = cmd + "\n" #+ msg + "\n"
      expect { DoCmd(cmd) }.to output(eq(t_msg)).to_stdout
    end

  end

  
  describe 'Notice(message)' do

    it 'test an output of Notice' do
      msg = "This is Test Message"
      head = "[NOTICE] "
      foot = "\n"
      t_msg = [head, msg, foot].join
      expect { Notice(msg) }.to output(eq(t_msg)).to_stdout
    end
    
  end

  describe 'Waring(message)' do

    it 'test an output of Warning' do
      msg = "This is Test Message"
      head = "[WARNING] "
      foot = "\n"
      t_msg = [head, msg, foot].join
      expect { Warning(msg) }.to output(eq(t_msg)).to_stdout
    end
    
  end

  
  describe 'Error(message)' do

    it 'test an output of Error' do
      msg = "This is Test Message"
      head = "[ERROR] "
      foot = "\n"
      t_msg = [head, msg, foot].join
      expect { Error(msg) }.to output(eq(t_msg)).to_stdout
    end

  end

  
  describe 'YNInputWaiting(not_interactive = false)' do


    context 'case) return = true' do

      example 'if "not_interactice = true" is set ' do
        expect(YNInputWaiting(not_interactive = true)).to eq(true)
      end

      specify 'confirm an output if "not_interactice = true" is set ' do
        msg = "[YES/no]: YES"
        head = ""
        foot = "\n"
        t_msg = [head, msg, foot].join
        expect { YNInputWaiting(not_interactive = true) }.to output(eq(t_msg)).to_stdout
      end

=begin
I will write tests which confirm STDIN of YNInputWaiting, and os
=end
      
    end
  end

  
end
