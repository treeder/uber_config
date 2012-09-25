UberConfig is a config loader that will load config files from various locations.

# New in 1.0

- Will look for both yml AND json files
- Added :ext option to choose config extension
- Indifferent access so you can use either symbols or strings for keys

# Usage

Just run:

    config = UberConfig.load

It will look `config.yml` or `config.json` by default. You can change what it will look for and
where with the different load() options.

Here is the order of where it looks:

- $abt_config global variable (for https://github.com/iron-io/abt)
- directory of file that calls UberConfig.load
- working directory
- TODO: look at ~/configs/#{working_directory_name} directory
- ~/Dropbox/configs/#{working_directory_name}

:dir can be used to change working_directory_name.

