#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'mupdater-function'

##############
# parameters #
##############
PROGRAM       = 'mupdater'
UPGRADE_OPTS  = 'configure.optflags="-I/opt/X11/include -O2" '
PORT_OPTS     = '-v'

proxy = { port: '',
          id: '',
          password: '',
          domain: '',
          url: '' }

opts = {  port_selfupdate: true,
          port_upgrade: true,
          port_clean: false,
          port_inactive: false,
          port_inactive_confirmation: false,
          proxy: false,
          rubygem_update: false,
          rubygem_cleanup: false,
          rubygem_option: true,
          pip_update: false,
          pip_option: true,
          verbose_mode: true,
          not_interactive: false }

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

def opts_parse(input_opts)
  opts = input_opts
  ARGV.options do |o|
    o.on('-v', '--verbose', 'Verbose mode [on/off (default:on)]') do |x|
      opts[:verbose_mode] = if x == 'off'
                              false
                            else
                              true
                            end
    end
    o.on('-y', '--yes', 'Do not ask yes or not every time (all YES)') do
      notice('...ALL YES MODE...')
      opts[:not_interactive] = true
    end
    o.on('-r X', '--rubygem X', 'Updating or cleanup rubygem and gems. [on/off/cleanup (default:off)]') do |x|
      if x == 'on'
        opts[:rubygem_update] = true
      elsif x == 'off'
        opts[:rubygem_update] = false
      elsif x == 'cleanup'
        opts[:rubygem_cleanup] = true
      else
        opts[:rubygem_update] = false
      end
    end
    o.on('-p X', '--pip', 'Updating pip and eggs.') do |x|
      opts[:pip_update] = if x == 'on'
                            true
                          else
                            false
                          end
    end
    o.on('-s X', '--selfupdate X', 'macports selfupdate.[on/off (default: on)]') do |x|
      if x == 'off'
        opts[:port_selfupdate] = false
        skip_message('macports selfupdate')
      end
    end
    o.on('-u X', '--upgrade X', 'macports upgrade installed. [on/off(default: on)]') do |x|
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
      installed_list = Open3.capture3('port installed | wc | awk \'{print $1}\'')
      active_list = Open3.capture3('port installed | grep active | wc | awk \'{print $1}\'')
      num_installed = installed_list[0].chomp!.to_i - 1 # remove macports messages
      num_active = active_list[0].chomp!.to_i
      notice("the numer of ports : installed => #{num_installed},
             active => #{num_active}\n")
      print('Do You want to exec "sudo port -v uninstall inactive"? [YES/no]:')
      e = STDIN.gets.split('\n')[0]
      puts 'your input:' + e
      if e == 'YES'.to_s
        opts[:port_inactivate_confirmation] = true
        notice('Start !')
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
      proxy[:url] = format('http://%<id>s:%<password>s@%<domain>s:%<port>s',
                            proxy[:id], proxy[:password], proxy[:domain], proxy[:port])
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
  opts
end

##########################
## main
##########################
if __FILE__ == $PROGRAM_NAME

  start_message
  error('This OS is not supported.') unless os_check

  notice('Parsing options start.')
  opts = opts_parse(opts)
  notice('Parsing options is done!!')

  if opts[:port_inactive] && opts[:port_inactivate_confirmation]
    puts '*****************************************'
    puts '*    sudo port -v uninstall inactive    *'
    puts '*****************************************'
    cmd = "sudo port #{PORT_OPTS} uninstall inactive"
    do_cmd(cmd)
    logout_process
  end
  if opts[:port_clean]
    puts '***************************************'
    puts '*    sudo port -v clean installed     *'
    puts '***************************************'
    cmd = "sudo port #{PORT_OPTS} clean --all installed"
    do_cmd(cmd)
    logout_process
  end
  if opts[:rubygem_update]
    # set options for rubygem
    opts_str = ''
    opts_str += ' --verbose' if opts[:rubygem_option] == true
    opts_str += " --remote --http-proxy=#{proxy[:url]}" if opts[:proxy] == true
    puts '*****************************'
    puts '*    gem update --system    *'
    puts '*****************************'
    cmd = 'gem update --system'
    cmd += opts_str
    do_cmd(cmd)
    puts '**********************'
    puts '*    gem outdated    *'
    puts '**********************'
    cmd = 'gem outdated'
    cmd += opts_str
    do_cmd(cmd)
    notice('Do you want to update all gems？')
    yn = yn_input_waiting(opts[:not_interactive])
    if yn
      puts '********************'
      puts '*    gem update    *'
      puts '********************'
      cmd = 'gem update'
      cmd += opts_str
      do_cmd(cmd)
    else
      skip_message('gem update')
    end
  end
  if opts[:rubygem_cleanup]
    opts_str = ''
    opts_str += ' --dryrun'
    puts '******************************'
    puts '*    gem cleanup --dryrun    *'
    puts '******************************'
    cmd = 'gem cleanup'
    cmd += opts_str
    do_cmd(cmd)
    notice('Do you want to clean up gems?')
    yn = yn_input_waiting(opts[:not_interactive])
    if yn
      puts '*********************'
      puts '*    gem cleanup    *'
      puts '*********************'
      cmd = 'gem cleanup'
      do_cmd(cmd)
    else
      skip_message('gem cleanup')
    end
  end
  if opts[:pip_update]
    puts 'ongoing...'
    opts_str = '' # clear str tempolary
    puts '************************************'
    puts '*    pip list -o --format=columns  *'
    puts '************************************'
    cmd = 'pip list -o --format=columns'
    cmd += opts_str
    do_cmd(cmd)
    notice('Do you want to update all eggs？')
    yn = yn_input_waiting(opts[:not_interactive])
    if yn
      puts '*****************************************************************************************'
      puts '*    pip freeze --local | grep -v "^\-e" | cut -d = -f 1  | xargs -n1 pip install -U    *'
      puts '*****************************************************************************************'
      cmd = 'pip freeze --local'
      cmd += ' | grep -v "^\-e"'
      cmd += ' | cut -d = -f 1'
      cmd += ' | xargs -n1 pip install -U'
      cmd += opts_str
      do_cmd(cmd)
    else
      skip_message('pip install -U eggs')
    end
  end
  if opts[:port_selfupdate]
    puts '********************************'
    puts '*    sudo port -v selfupdate   *'
    puts '********************************'
    cmd = "sudo port #{PORT_OPTS} selfupdate"
    do_cmd(cmd)
    puts '**********************'
    puts '*    port outdated   *'
    puts '**********************'
    cmd = 'port outdated'
    do_cmd(cmd)
  end
  if opts[:port_upgrade]
    puts '****************************************'
    puts '*    sudo port -v upgrade installed    *'
    puts '****************************************'
    cmd = "sudo port #{PORT_OPTS} upgrade installed #{UPGRADE_OPTS}"
    do_cmd(cmd)
  end
  logout_process
end
