# mupdater
"mupdater" is a ruby program which help update macports, rubygems, and pip eggs.

# Requirement
"mupdater" needs ruby, optparse and open3.
```bash
$ gem install optparse rubysl-open3
```

# How to Use
```bash
[NOTICE] Parsing options start.
Usage: mupdater [options]
    -v, --verbose                    Verbose mode [on/off (default:on)]
    -r, --rubygem X                  Updating rubygem and gems. [on/off (default:off)]
    -p, --pip X                      Updating pip and eggs.
    -s, --selfupdate                 [Skip] macports selfupdate.
    -u, --upgrade                    [Skip] macports upgrade installed.
    -c, --clean                      Performing macports clean update
    -i, --inactivate                 Perform macports uninstall inactive.
        --proxy                      Set your proxy server.
```