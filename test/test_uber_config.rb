gem 'test-unit'
require 'test/unit'
require_relative '../lib/uber_config'

class TestUberConfig < Test::Unit::TestCase

  def test_loading
    @config = UberConfig.load
    p @config
  end

end