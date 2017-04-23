#!/usr/bin/env ruby
# codinf:utf-8
#

##########################
## function
##########################
# Ctrl + C trap
Signal.trap(:INT){
  puts "SIGINT"
  exit(0)
}

def LogoutProcess()
  #cmd ="growlnotify -m \"update.sh finished\""
  #system(cmd)
  puts "============================"
  puts "=                          ="
  puts "===  finish upgrader.rb  ==="
  puts "=                          ="
  puts "============================"
  exit
end

def StartMessage()
	puts "============================"
	puts "=                          ="
	puts "===  start upgrader.rb   ==="
	puts "=                          ="
	puts "============================"
end

def SkipMessage(message)
  puts "[SKIP] " + message + "...\n"
end

def DoCmd(cmd)
  puts cmd
  system(cmd)
end

def Notice(message)
  puts "[NOTICE] " + message
end

def Warning(message)
  puts "[WARNING] " + message
end

def Error(message)
  puts "[ERROR] " + message
end
