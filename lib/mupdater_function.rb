﻿#!/usr/bin/env ruby
# frozen_string_literal: true

###############
## library
###############
require 'rbconfig'
require 'optparse'
require 'open3'
require 'logger'

##########################
## function
##########################
# Ctrl + C trap
Signal.trap(:INT) do
  puts 'SIGINT'
  exit(0)
end

$log = Logger.new($stdout)
$log.progname = 'mupdater'
$log.formatter = proc do |severity, datetime, progname, msg|
  %({"severity": "#{severity}", "datetime": "#{datetime}", "progname": "#{progname}", "message": "#{msg}"}\n)
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

def skip_message(msg)
  puts format('[SKIP] %<message>s...', message: msg)
end

def do_cmd(cmd)
  puts format('[CMD] %<command>s', command: cmd)
  system(cmd)
  true
end

def notice(msg)
  puts format('[INFO] %<message>s', message: msg)
end

def warning(msg)
  puts format('[WARN] %<message>s', message: msg)
end

def error(msg)
  puts format('[ERR] %<message>s', message: msg)
  $log.error(msg)
end

def print_message(msg)
  num = msg.size
  l = ''
  (0..num - 1 + 6).each do |_i|
    l += '*'
  end
  puts l
  puts format('*  %<message>s  *', message: msg)
  puts l
end

def yn_input_waiting(not_interactive)
  print '[YES/no]: '
  if not_interactive
    puts 'YES'
    return true
  end
  g = gets
  return false if g.nil?

  yn = g.chomp.to_s
  return true if yn == 'YES'

  false
end

# rubocop:disable Metrics/MethodLength
def os
  # rubocop:disable Style/MultilineMemoization
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
  # rubocop:enable Style/MultilineMemoization
end
# rubocop:enable Metrics/MethodLength
