UberConfig is a config loader that will load config files from various locations.

Just run:

    config = UberConfig.load

Looks for `config.yml` file or name passed in via :file param.

Here is the order of where it looks:

- $abt_config global variable (for https://github.com/iron-io/abt)
- directory of file that calls UberConfig.load
- working directory
- TODO: look at ~/configs directory
- ~/Dropbox/configs/#{working_directory_name}

:dir can be used to change working_directory_name.

## Helper methods

### Symbolize Keys

When it loads up config files, the hash keys will be strings by default because they are
strings in the files. You can convert them to keys by running `UberConfig.symbolize_keys!`, for example:

    config = UberConfig.load
    config = UberConfig.symbolize_keys!(config)

