#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# convert update.sh to update.rb
# rename update.rb "updater.rb"
#

require_relative 'mupdater-function'


##############
# parameters #
##############
PROGRAM="mupdater"
UPGRADE_OPTS="configure.optflags='-I/opt/X11/include -O2' "
#UPGRADE_OPTS="configure.optflags='-I/opt/X11/include -O2' configure.cppflags='-I/opt/X11/include -O2'"
PORT_OPTS="-v"

proxy = {:port => "",
         :id => "",
         :password => "",
         :domain => "",
         :url => ""}

opts = {:port_selfupdate => true,
        :port_upgrade => true,
        :port_clean => false,
        :port_inactive => false,
        :port_inactive_confirmation => false,
        :proxy => false,
        :rubygem_update => false,
        :rubygem_cleanup => false,
        :rubygem_option => true,
        :pip_update => false,
        :pip_option => true,
        :verbose_mode => true,
        :not_interactive => false}
  

#############
# functions #
#############
def os_check
  os_check = {:windows => false,
              :macosx => true,
              :linux => true,
              :unix => false,
              :unknown => false}

  Notice("This platform is #{os}.")
  if !os_check[os] then
    Error("This system is able to run on macosx or linux.\n")
    exit(0)
  else
    Notice('This program supports this OS.')
  end

end


def opts_parse(input_opts)
  opts = input_opts
  ARGV.options do |o|
    o.on("-v", "--verbose", "Verbose mode [on/off (default:on)]"){|x|
      if "off" == x
        opts[:verbose_mode] = false
      elsif "on" == x
        opts[:verbose_mode] = true
      else
        opts[:verbose_mode] = true
      end
    }
    o.on("-y","--yes","Do not ask yes or not every time (all YES)"){
      Notice("...ALL YES MODE...")
      opts[:not_interactive] = true
    }
    o.on("-r X", "--rubygem X", "Updating or cleanup rubygem and gems. [on/off/cleanup (default:off)]"){|x|
      if "on" == x
        opts[:rubygem_update] = true
      elsif "off" == x
        opts[:rubygem_update] = false
      elsif "cleanup" == x
        opts[:rubygem_cleanup] = true
      else
        opts[:rubygem_update] = false
      end
      # SkipMessage("rubygem update")
    }
    o.on("-p X","--pip","Updating pip and eggs."){|x|
      if "on" == x
        opts[:pip_update] = true
      elsif "off" == x
        opts[:pip_update] = false
      else
        opts[:pip_update] = false
      end
    }
    o.on("-s X", "--selfupdate X", "macports selfupdate.[on/off (default: on)]"){|x|
      if "off" == x
        opts[:port_selfupdate] = false
        SkipMessage("macports selfupdate")
      end
    }
    o.on("-u X", "--upgrade X", "macports upgrade installed. [on/off(default: on)]"){|x|
      if "off" == x
        opts[:port_upgrade] = false
        SkipMessage("macports update installed")
      end
    }
    o.on("-c", "--clean", "Performing macports clean update"){|x|
      opts[:port_clean] = true }
    o.on("-i", "--inactivate", "Perform macports uninstall inactive."){|x|
      opts[:port_inactive] = true
      installed_list = Open3.capture3("port installed | wc | awk '{print $1}'")
      active_list = Open3.capture3("port installed | grep active | wc | awk '{print $1}'")
      num_installed = installed_list[0].chomp!.to_i - 1 # remove macports messages
      num_active = active_list[0].chomp!.to_i
      Notice("the numer of ports : installed => #{num_installed}, active => #{num_active}\n")
      print("Do You want to perform \"sudo port -v uninstall inactive\"? [YES/no]:")
      e = STDIN.gets.split("\n")[0]
      puts "your input:"+ e
      if e == "YES".to_s
        opts[:port_inactivate_confirmation] = true
        Notice("Start !")
      else
        Notice("Cancel \"sudo port -v uninstall inactive\"")
      end
    }
    o.on("--proxy", "Set your proxy server."){
      opts[:rubygem_option] = true
      opts[:pip_option] = true
      opts[:proxy] = true
      Notice("Set your proxy environment [id / password / domain / port].")
      print "id?: "
      proxy[:id] = gets.chomp.to_s
      print "password?: "
      proxy[:password] = gets.chomp.to_s
      print "domain?: "
      proxy[:domain] = gets.chomp.to_s
      print "port?: "
      proxy[:port] = gets.chomp.to_s
      proxy[:url] = sprintf("http://%s:%s@%s:%s",
                           proxy[:id],
                           proxy[:password],
                           proxy[:domain],
                           proxy[:port])
    }
    o.parse!
  end

  # Not mac os
  if os != :macosx
    # all of values invloving in MacPorts shoud be false 
    keys = [:port_selfupdate, :port_upgrade, :port_clean, :port_inactive, :port_inactive_confirmation, :port_inactivate_confirmation]
    for key in keys
      opts[key] = false
    end
  end 

  return opts
  
end


##########################
## main
##########################
if __FILE__ == $0

  StartMessage()
  os_check()

  Notice("Parsing options start.")

  
  opts = opts_parse(opts)
  

  #puts "...done!!!"
  Notice("Parsing options is done!!")
  
  if opts[:port_inactive] and opts[:port_inactivate_confirmation] then
    puts "*****************************************"
    puts "*    sudo port -v uninstall inactive    *"
    puts "*****************************************"
    #sudo port -v uninstall inactive
    #sudo port -d uninstall inactive
    cmd = "sudo port #{PORT_OPTS} uninstall inactive"
    DoCmd(cmd)
    LogoutProcess()
  end
  if opts[:port_clean] then
    puts "***************************************"
    puts "*    sudo port -v clean installed     *"
    puts "***************************************"
    cmd = "sudo port #{PORT_OPTS} clean --all installed"
    DoCmd(cmd)
    LogoutProcess()
  end
  if opts[:rubygem_update] then
    # set options for rubygem
    opts_str = ""
    opts_str = opts_str + " --verbose" if opts[:rubygem_option] == true
    opts_str = opts_str + " --remote --http-proxy=#{proxy[:url]}" if opts[:proxy] == true
    puts "*****************************"
    puts "*    gem update --system    *"
    puts "*****************************"
    cmd = "gem update --system" + opts_str
    DoCmd(cmd)
    puts "**********************"
    puts "*    gem outdated    *"
    puts "**********************"
    cmd = "gem outdated" + opts_str
    DoCmd(cmd)
    Notice("Do you want to update all gems？")
    yn = YNInputWaiting(not_interactive = opts[:not_interactive])
    if yn then
      puts "********************"
      puts "*    gem update    *"
      puts "********************"
      cmd = "gem update" + opts_str
      DoCmd(cmd)
    else
      SkipMessage("gem update")
    end
  end
  if opts[:rubygem_cleanup] then
    opts_str = ""
    opts_str = opts_str + " --dryrun"
    puts "******************************"
    puts "*    gem cleanup --dryrun    *"
    puts "******************************"
    cmd = "gem cleanup" + opts_str
    DoCmd(cmd)
    Notice("Do you want to clean up gems?")
    yn = YNInputWaiting(not_interactive = opts[:not_interactive])
    if yn then
      puts "*********************"
      puts "*    gem cleanup    *"
      puts "*********************"
      cmd = "gem cleanup"
      DoCmd(cmd)
    else
      SkipMessage("gem cleanup")
    end
  end
  if opts[:pip_update] then
    puts "ongoing..."
    opts_str = "" # clear str tempolary
    puts "************************************"
    puts "*    pip list -o --format=columns  *"
    puts "************************************"
    cmd = "pip list -o --format=columns" + opts_str
    DoCmd(cmd)
    Notice("Do you want to update all eggs？")
    yn = YNInputWaiting(not_interactive = opts[:not_interactive])
    if yn then
      puts "*****************************************************************************************"
      puts "*    pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U    *"
      puts "*****************************************************************************************"
      cmd = "pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U" + opts_str
      DoCmd(cmd)
    else
      SkipMessage("pip install -U eggs")
    end
  end
  if opts[:port_selfupdate] then
    puts "********************************"
    puts "*    sudo port -v selfupdate   *"
    puts "********************************"
    cmd = "sudo port #{PORT_OPTS} selfupdate"
    DoCmd(cmd)
    puts "**********************"
    puts "*    port outdated   *"
    puts "**********************"
    cmd = "port outdated"
    DoCmd(cmd)
  end
  if opts[:port_upgrade] then
    puts "****************************************"
    puts "*    sudo port -v upgrade installed    *"
    puts "****************************************"
    cmd = "sudo port #{PORT_OPTS} upgrade installed #{UPGRADE_OPTS}"
    DoCmd(cmd)
  end
  LogoutProcess()
end
