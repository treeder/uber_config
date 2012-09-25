gem 'test-unit'
require 'test/unit'
require_relative '../lib/uber_config'

class TestUberConfig < Test::Unit::TestCase

  def test_loading
    @config = UberConfig.load
    p @config

    assert_equal "value", @config['ymlx']
    assert_equal "value", @config[:ymlx]
    p @config[:outer]
    assert_equal "inside", @config[:outer][:inner]

    @config = UberConfig.load(:ext=>'json')
    p @config
    assert_equal "value", @config['jsonx']
    assert_equal "value", @config[:jsonx]

    @config = UberConfig.load(:file=>"config2")
    p @config
    assert_equal "value2", @config['jsonx']
    assert_equal "value2", @config[:jsonx]


  end

  def test_symbolize
    x = {"hello"=>"there", :hi=>"yo"}
    UberConfig.symbolize_keys!(x)
    p x
  end

end