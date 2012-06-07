UberConfig is a config loader that will load config files from various locations.

Looks for `config.yml` file or name passed in via :file param.

Here is the order:

- $abt_config global variable (for https://github.com/iron-io/abt)
- test directory
- directory of file that calls UberConfig.load
- working directory
- ~/Dropbox/configs/#{working_directory_name}

:dir can be used to change working_directory_name.

