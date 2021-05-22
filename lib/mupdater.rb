#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'mupdater_function'

##############
# parameters #
##############
PROGRAM       = 'mupdater'
UPGRADE_OPTS  = 'configure.optflags="-I/opt/X11/include -O2" '
PORT_OPTS     = '-v'

#############
# functions #
#############
def os_check
  os_check = {  windows: false,
                macosx: true,
                linux: true,
                unix: false,
                unknown: false }
  notice("This platform is #{os}.")
  os_check[os]
end

#################
# option parser #
#################

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/PerceivedComplexity
def option_parser
  proxy = { port: '',
            id: '',
            password: '',
            domain: '',
            url: '' }

  opts = { port_selfupdate: true,
           port_upgrade: true,
           port_clean: false,
           port_inactive: false,
           port_inactive_confirmation: false,
           proxy: false,
           proxy_params: {},
           rubygem_update: false,
           rubygem_cleanup: false,
           rubygem_option: true,
           pip_update: false,
           pip_option: true,
           verbose_mode: true,
           not_interactive: false }

  notice('Parsing options start.')
  # rubocop:disable Metrics/BlockLength
  ARGV.options do |o|
    o.on('-v', '--verbose', 'Verbose mode [on/off (default:on)]') do |x|
      opts[:verbose_mode] = x != 'off'
    end
    o.on('-y', '--yes', 'Do not ask yes or not every time (all YES)') do
      notice('...ALL YES MODE...')
      opts[:not_interactive] = true
    end
    o.on('-r X', '--rubygem X',
         'Updating or cleanup rubygem and gems. [on/off/cleanup]') do |x|
      case x
      when 'on'
        opts[:rubygem_update] = true
      when 'off'
        opts[:rubygem_update] = false
      when 'cleanup'
        opts[:rubygem_cleanup] = true
      end
    end
    o.on('-p X', '--pip', 'Updating pip and eggs.') do |x|
      opts[:pip_update] = x == 'on'
    end
    o.on('-s X', '--selfupdate X', 'macports selfupdate.[on/off]') do |x|
      if x == 'off'
        opts[:port_selfupdate] = false
        skip_message('macports selfupdate')
      end
    end
    o.on('-u X', '--upgrade X', 'macports upgrade installed. [on/off]') do |x|
      if x == 'off'
        opts[:port_upgrade] = false
        skip_message('macports update installed')
      end
    end
    o.on('-c', '--clean', 'Performing macports clean update') do
      opts[:port_clean] = true
    end
    o.on('-i', '--inactivate', 'Perform macports uninstall inactive.') do
      opts[:port_inactive] = true
      cmd = 'port installed | wc | awk \'{print $1}\''
      installed_list = Open3.capture3(cmd)
      cmd = 'port installed | grep active | wc | awk \'{print $1}\''
      active_list = Open3.capture3(cmd)
      # remove macports messages
      num_installed = installed_list[0].chomp!.to_i - 1
      num_active = active_list[0].chomp!.to_i
      notice('the numer of ports :')
      notice("installed => #{num_installed}, active => #{num_active}\n")
      notice('Do You want to exec "sudo port -v uninstall inactive"?')
      if yn_input_waiting(opts[:not_interactive])
        opts[:port_inactivate_confirmation] = true
        notice('Start uninstall inactive ports!')
      else
        notice('Cancel \'sudo port -v uninstall inactive\'')
      end
    end
    o.on('--proxy', 'Set your proxy server.') do
      opts[:rubygem_option] = true
      opts[:pip_option] = true
      opts[:proxy] = true
      notice('Set your proxy environment [id / password / domain / port].')
      print 'id?: '
      proxy[:id] = gets.chomp.to_s
      print 'password?: '
      proxy[:password] = gets.chomp.to_s
      print 'domain?: '
      proxy[:domain] = gets.chomp.to_s
      print 'port?: '
      proxy[:port] = gets.chomp.to_s
      # rubocop:disable Lint/FormatParameterMismatch
      proxy[:url] = format('http://%<id>s:%<password>s@%<domain>s:%<port>s',
                           proxy[:id],
                           proxy[:password],
                           proxy[:domain],
                           proxy[:port])
      opts[:proxy_params] = proxy
      # rubocop:enable Lint/FormatParameterMismatch
    end
    o.on('-T X', '--TimeMachine X',
         'checking status of TimeMachine for macOS and\
          delete its local backup data which ocupies its SSD.\
          [check/cleanup]') do |x|
      if os != :macosx
        puts 'This option is valid on macOS only.'
        break
      end
      case x
      when 'check'
        opts[:time_machine_check] = true
      when 'cleanup'
        opts[:time_machine_cleanup] = true
      else
        warning('invalid option. skip this args.')
      end
    end
    o.parse!
  end
  # Not mac os
  if os != :macosx
    # all of values invloving in MacPorts shoud be false
    keys = %I[  port_selfupdate
                port_upgrade
                port_clean
                port_inactive
                port_inactive_confirmation
                port_inactivate_confirmation  ]
    keys.each do |k|
      opts[k] = false
    end
  end
  # rubocop:enable Metrics/BlockLength
  notice('Finish to parse opts.')
  opts
end

# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/PerceivedComplexity

##########################
## function
##########################
###
# time machine
###
def time_machine_listdisplay
  print_message('tmutil listlocalsnapshots /')
  cmd = 'tmutil listlocalsnapshots /'
  do_cmd(cmd)
  true
end

def time_machine_checker
  print_message('cleanup Time Machine')
  cmd = "for d in `tmutil listlocalsnapshots /\
   | awk -F'.\' \'\{print $4\}\'`;\
   do sudo tmutil deletelocalsnapshots $d; done"
  do_cmd(cmd)
  true
end

###
# macports
###
def macport_inactive_uninstaller
  print_message('sudo port -v uninstall inactive')
  cmd = "sudo port #{PORT_OPTS} uninstall inactive"
  do_cmd(cmd)
end

def macport_cleaner
  print_message('sudo port -v clean installed')
  cmd = "sudo port #{PORT_OPTS} clean --all installed"
  do_cmd(cmd)
end

def macport_selfupdater
  print_message('sudo port -v selfupdate')
  cmd = "sudo port #{PORT_OPTS} selfupdate"
  do_cmd(cmd)
  print_message('port outdated')
  cmd = 'port outdated'
  do_cmd(cmd)
end

def macport_upgrader
  print_message('sudo port -v upgrade installed')
  cmd = "sudo port #{PORT_OPTS} upgrade installed #{UPGRADE_OPTS}"
  do_cmd(cmd)
end

###
# rubygem
###
def rubygem_updater_cmd(opts_str)
  cmd = 'gem update --system'
  cmd += opts_str
  cmd
end

def rubygem_outdated_cmd(opts_str)
  cmd = 'gem outdated'
  cmd += opts_str
  cmd
end

def rubygem_updater(opts, opts_str)
  notice('Do you want to update all gems?')
  if yn_input_waiting(opts[:not_interactive])
    print_message('gem update')
    cmd = 'gem update'
    cmd += opts_str
    do_cmd(cmd)
  else
    skip_message('gem update')
  end
  true
end

def rubygem_opts_builder(opts)
  opts_str = ''
  opts_str += ' --verbose' if opts[:rubygem_option] == true
  opts_str += " --remote --http-proxy=#{opts[:proxy_params][:url]}" if opts[:proxy] == true
  opts_str
end

def rubygem_update_handler(opts)
  opts_str = rubygem_opts_builder(opts)
  print_message('gem update --system')
  do_cmd(rubygem_updater_cmd(opts_str))
  print_message('gem outdated')
  do_cmd(rubygem_outdated_cmd(opts_str))
  rubygem_updater(opts, opts_str)
end

def rubygem_cleaner(opts)
  notice('Do you want to clean up gems?')
  if yn_input_waiting(opts[:not_interactive])
    print_message('gem cleanup')
    cmd = 'gem cleanup'
    do_cmd(cmd)
  else
    skip_message('gem cleanup')
  end
  true
end

def rubygem_clean_handler(opts)
  opts_str = ''
  opts_str += ' --dryrun'
  print_message('gem cleanup --dryrun')
  cmd = 'gem cleanup'
  cmd += opts_str
  do_cmd(cmd)
  rubygem_cleaner(opts)
end

###
# pip
###
def pip_updater(opts, opts_str)
  notice('Do you want to update all eggs？')
  if yn_input_waiting(opts[:not_interactive])
    print_message('Updating pip modules')
    cmd = 'pip freeze --local | grep -v "^\-e" | cut -d = -f 1 | xargs -n1 pip install -U'
    cmd += opts_str
    do_cmd(cmd)
  else
    skip_message('pip install -U eggs')
  end
  true
end

def pip_update_handler(opts)
  puts 'ongoing...'
  opts_str = '' # clear str tempolary
  print_message('pip list -o --format=columns')
  cmd = 'pip list -o --format=columns'
  cmd += opts_str
  do_cmd(cmd)
  pip_updater(opts, opts_str)
end

##########################
## main
##########################
def optional_handler(opts)
  return time_machine_listdisplay if opts[:time_machine_check]
  return time_machine_checker if opts[:time_machine_cleanup]
  return macport_inactive_uninstaller if opts[:port_inactive] && opts[:port_inactivate_confirmation]
  return macport_cleaner if opts[:port_clean]
end

def main_handler(opts)
  optional_handler(opts)

  rubygem_update_handler(opts) if opts[:rubygem_update]
  rubygem_clean_handler(opts) if opts[:rubygem_cleanup]
  pip_update_handler(opts) if opts[:pip_update]
  macport_selfupdater if opts[:port_selfupdate]
  macport_upgrader if opts[:port_upgrade]
  true
end

if __FILE__ == $PROGRAM_NAME

  error('This OS is not supported.') unless os_check
  opts = option_parser
  error('main handler did not return true') unless main_handler(opts)
  logout_process
end
