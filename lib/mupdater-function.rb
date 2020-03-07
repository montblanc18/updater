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
Signal.trap(:INT) do
  puts 'SIGINT'
  exit(0)
end

def logout_process
  logout_message
  exit 0
end

def logout_message
  puts '========================='
  puts '=                       ='
  puts '===  finish mupdater  ==='
  puts '=                       ='
  puts '========================='
end

def start_message
  puts '========================='
  puts '=                       ='
  puts '===  start mupdater   ==='
  puts '=                       ='
  puts '========================='
end

def skip_message(message)
  puts '[SKIP] ' + message + '...\n'
end

def do_cmd(cmd)
  puts cmd
  system(cmd)
end

def notice(message)
  puts '[INFO] ' + message
end

def warning(message)
  puts '[WARN] ' + message
end

def error(message)
  puts '[ERR] ' + message
end

def yn_input_waiting(not_interactive)
  print '[YES/no]: '
  if not_interactive == true
    print 'YES\n'
    true
  end
  yn = gets.chomp.to_s
  true if yn == 'YES'
  false
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
