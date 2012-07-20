gem 'test-unit'
require 'test/unit'
require_relative '../lib/uber_config'

class TestUberConfig < Test::Unit::TestCase

  def test_loading
    @config = UberConfig.load
    p @config
  end

  def test_symbolize
    x = {"hello"=>"there", :hi=>"yo"}
    UberConfig.symbolize_keys!(x)
    p x
  end

end