# coding: utf-8

require 'mupdater-function'

RSpec.describe  'mupdater-function' do 
  
  context 'LogoutProcess' do
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

  context 'StartMessage' do
    it 'confirm output.' do
      t_msg = ["=========================\n",
               "=                       =\n",
               "===  start mupdater   ===\n",
               "=                       =\n",
               "=========================\n"].join
      expect { StartMessage() }.to output(eq(t_msg)).to_stdout
    end
  end
  
  context 'SkipMessage' do
    it 'test an output of SkipMessage' do
      msg = "This is Test Message"
      head = "[SKIP] "
      foot = "...\n"
      t_msg = [head, msg, foot].join
      expect { SkipMessage(msg) }.to output(eq(t_msg)).to_stdout
    end
  end
end
