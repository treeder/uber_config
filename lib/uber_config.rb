require 'yaml'
require 'logger'
require 'uber_config/version'
require 'open-uri'

module UberConfig

  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO

  def self.logger
    @@logger
  end

  def self.logger=(l)
    @@logger = l
  end


  # Load a config file from various system locations
  # Options:
  #   :file => filename, default is 'config' which means it will look for both config.yml and config.json. You can use the full filename like 'config.json'
  #   :dir => directory to look for in the default locations
  #   :ext => extension, either yml or json. Default will check both.
  def self.load(options={})

    # First check for abt config: https://github.com/iron-io/abt
    if defined? $abt_config
      logger.info "$abt_config found."
      @config = $abt_config
      return @config
    end

    if ENV['CONFIG_CACHE_KEY']
      logger.info "ENV[CONFIG_CACHE_KEY] found."
      logger.debug "Getting config from #{ENV['CONFIG_CACHE_KEY']}"
      config_from_cache = open(ENV['CONFIG_CACHE_KEY']).read
      config_from_cache = JSON.parse(config_from_cache)
      config_from_cache = YAML.load(config_from_cache['value'])
      logger.info  "Got config from cache."
      set_default_proc(config_from_cache)
      return config_from_cache
    end

    dir = nil
    if options[:dir]
      dir = options[:dir]
      if dir.is_a?(String)
        dir = [dir]
      end
    end

    file = options[:file] || "config"
    ext = options[:ext]
    filenames = []
    if file.include?(".") # then has extension
      filenames << file
    else
      if ext
        filenames << "#{file}.#{ext}"
      else
        filenames << "#{file}.yml"
        filenames << "#{file}.json"
      end
    end

    #p Kernel.caller
    caller_file = caller[0][0...(caller[0].index(":in"))]
    caller_file = caller_file[0...(caller_file.rindex(":"))]
    #p caller_file
    caller_dir = File.dirname(caller_file)
    #puts "caller_dir: " + caller_dir
    caller_dir = File.expand_path(caller_dir)
    #puts "caller_dir: " + caller_dir
    caller_dir_split = caller_dir.split("/")
    #p caller_dir_split
    auto_dir_name = caller_dir_split.last
    if auto_dir_name == "test"
      caller_dir_split.pop
      auto_dir_name = caller_dir_split.last
    end

    # Now check near caller file
    filenames.each do |file|
      dir_and_file = dir.nil? ? [] : dir.dup
      dir_and_file << file
      #p dir_and_file
      location = File.join(dir_and_file)
      #p location
      cf = File.expand_path(location, caller_dir)
      @config = load_from(cf)
      return @config if @config

      # and working directory
      cf = File.expand_path(location)
      @config = load_from(cf)
      return @config if @config

    end

    # Now check in Dropbox
    filenames.each do |file|
      dropbox_folders = ["~", "Dropbox", "configs"]
      if dir
        dropbox_folders = dropbox_folders + dir
      else
        dropbox_folders = dropbox_folders << auto_dir_name
      end
      dropbox_folders << file
      cf = File.expand_path(File.join(dropbox_folders))
      @config = load_from(cf)
      return @config if @config
    end

    # couldn't find it
    raise "UberConfig could not find config file!"

  end

  def self.load_from(cf)
    logger.info "Checking for config file at #{cf}..."
    if File.exist?(cf)
      config = YAML::load_file(cf)
      # the following makes it indifferent access, but doesn't seem to for inner hashes
      set_default_proc(config)
      return config
    end
    nil
  end

  def self.set_default_proc(hash)
    #puts 'setting default proc'
    #p hash
    hash.default_proc = proc do |h, k|
      case k
        when String
          sym = k.to_sym; h[sym] if h.key?(sym)
        when Symbol
          str = k.to_s; h[str] if h.key?(str)
      end
    end
    hash.each_pair do |k, v|
      if v.is_a?(Hash)
        set_default_proc(v)
      end
    end

  end

  # Destructively convert all keys to symbols, as long as they respond to to_sym.
  # inspired by activesupport
  def self.symbolize_keys!(hash)
    keys = hash.keys
    keys.each do |key|
      v = hash.delete(key)
      if v.is_a?(Hash)
        v = symbolize_keys!(v)
      end
      hash[(key.to_sym rescue key) || key] = v
    end
    hash
  end

  # Non destructive, returns new hash.
  def self.symbolize_keys(hash)
    keys = hash.keys
    ret = {}
    keys.each do |key|
      v = hash[key]
      if v.is_a?(Hash)
        v = symbolize_keys(v)
      end
      ret[(key.to_sym rescue key) || key] = v
    end
    ret
  end

  def self.make_indifferent(hash)
    hash.default_proc = proc do |h, k|
      case k
        when String then
          sym = k.to_sym; h[sym] if h.key?(sym)
        when Symbol then
          str = k.to_s; h[str] if h.key?(str)
      end
    end
  end

end
