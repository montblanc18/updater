# mupdater
`mupdater` is a ruby program which help update macports, rubygems, and pip modules.
mupdater means "my updater".


# Requirement
`mupdater` needs ruby, optparse and open3 except some commands (`port`, `gem`, and `pip`) .

```bash
$ gem install optparse rubysl-open3
$ echo "export PATH=INSTALL_HOME_DIR/bin:$PATH" > .bashrc
```

# How to Use

```text
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

# Support

This program support macos or linux.
If your platform is not macosx or linux, `mupdater` does not execute all commands which run macports.

# Development
This porgram is tested by RSpec.
```text
$ rspec
```

Please use `rubocop` before merge.
```text
$ rubocop
```
