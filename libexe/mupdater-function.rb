#!/usr/bin/env ruby
# codinf:utf-8
#

###############
## library
###############
require 'rbconfig'
require 'optparse'
require 'open3'

##########################
## function
##########################
# Ctrl + C trap
Signal.trap(:INT){
  puts "SIGINT"
  exit(0)
}

def LogoutProcess()
  #cmd ="growlnotify -m \"mupdater is finished\""
  #system(cmd)
  puts "========================="
  puts "=                       ="
  puts "===  finish mupdater  ==="
  puts "=                       ="
  puts "========================="
  exit
end

def StartMessage()
	puts "========================="
	puts "=                       ="
	puts "===  start mupdater   ==="
	puts "=                       ="
	puts "========================="
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

def YNInputWaiting(not_interactive = false)
  print "[YES/no]:"
  if true == not_interactive
    print "YES\n"
    return true
  end
  yn = gets.chomp.to_s
  return true if "YES" == yn
  return false
end

def os
    @os ||= (
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
      :macosx
    when /linux/
      :linux
    when /solaris|bsd/
      :unix
    else
      :unknown
    end
  )
end
