# To use, add the following to your Rakefile
#desc 'Pushes config to IronCache and sets Heroku config variable.'
#namespace :config do
#  task :push do
#    UberConfig.push_heroku
#  end
#end

module UberConfig

  module Pusher

    require 'iron_cache'

    def self.push
      config = UberConfig.load
      raise "Config needs an app_name field." unless config['app_name']

      c = IronCache::Client.new(config['iron'])
      cache = c.cache("configs")
      item = cache.put(config['app_name'], config.to_yaml)
      p item

      url = cache.url(config['app_name'])
      url_with_token = url + "?oauth=#{c.token}"
      url_with_token
    end

    def self.push_heroku
      url_with_token = push

      #puts url_with_token
      puts `heroku config:add CONFIG_CACHE_KEY=#{url_with_token}`

    end
  end
end
