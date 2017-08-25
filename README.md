# mupdater
"mupdater" is a ruby program which help update macports, rubygems, and pip eggs.

# Requirement
"mupdater" needs ruby, optparse and open3.
```bash
$ gem install optparse rubysl-open3
$ echo "export PATH=INSTALL_HOME_DIR/bin:$PATH" > .bashrc
```

# How to Use
```bash
Usage: mupdater [options]
    -v, --verbose                    Verbose mode [on/off (default:on)]
    -y, --yes                        Do not ask yes or not every time (all YES)
    -r, --rubygem X                  Updating or cleanup rubygem and gems. [on/off/cleanup (default:off)]
    -p, --pip X                      Updating pip and eggs.
    -s, --selfupdate X               [Skip] macports selfupdate.
    -u, --upgrade X                  [Skip] macports upgrade installed.
    -c, --clean                      Performing macports clean update
    -i, --inactivate                 Perform macports uninstall inactive.
        --proxy                      Set your proxy server.
```