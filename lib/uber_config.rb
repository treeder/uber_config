require "uber_config/version"

module UberConfig

  # Load a config file from various system locations
  def self.load(options={})

    # First check for abt config
    if defined? $abt_config
      puts "$abt_config found."
      @config = $abt_config
      return @config
    end

    dir = nil
    if options[:dir]
      dir = options[:dir]
      if dir.is_a?(String)
        dir = [dir]
      end
    end
    file = "config.yml"
    if options[:file]
      file = options[:file]
    end

    #p Kernel.caller
    caller_file = caller[0][0...(caller[0].index(":in"))]
    caller_file = caller_file[0...(caller_file.rindex(":"))]
    #p caller_file
    caller_dir = File.dirname(caller_file)
    #p caller_dir
    caller_dir_split = caller_dir.split("/")
    #p caller_dir_split
    auto_dir_name = caller_dir_split.last
    if auto_dir_name == "test"
      caller_dir_split.pop
      auto_dir_name = caller_dir_split.last
    end
    #p auto_dir_name

    # Now check near caller file
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


    # Now check in Dropbox
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

    # couldn't find it
    puts "Could not find config file."
    return nil

  end

  def load_from(cf)
    puts "Checking for config file at #{cf}..."
    if File.exist?(cf)
      config = YAML::load_file(cf)
      return config
    end
    nil
  end
end
