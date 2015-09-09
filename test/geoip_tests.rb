# encoding: UTF-8

$: << File.dirname(__FILE__)
require 'test_helper'

class GeoIPTest < Minitest::Test
  def setup
    @ip = "24.24.24.24"
    @ipnum = 16777216 * 24 + 65536 * 24 + 256 * 24 + 24

    @large_ip = "245.245.245.245"
    @large_ipnum = 16777216 * 245 + 65536 * 245 + 256 * 245 + 245
  end

  def test_addr_to_num_converts_an_ip_to_an_ipnum
    assert_equal @ipnum, GeoIP.addr_to_num(@ip)
  end

  def test_addr_to_num_converts_large_ips_to_an_ipnum_correctly
    assert_equal @large_ipnum, GeoIP.addr_to_num(@large_ip)
  end

  def test_addr_to_num_expects_an_ip_string
    assert_raises TypeError do
      GeoIP.addr_to_num(nil)
    end
  end

  def test_addr_to_num_returns_zero_for_an_illformed_ip_string
    assert_equal 0, GeoIP.addr_to_num("foo.bar")
  end

  def test_num_to_addr_converts_an_ipnum_to_an_ip
    assert_equal @ip, GeoIP.num_to_addr(@ipnum)
  end

  def test_num_to_addr_converts_large_ipnums_to_an_ip_correctly
    assert_equal @large_ip, GeoIP.num_to_addr(@large_ipnum)
  end

  def test_num_to_addr_expects_a_numeric_ip
    assert_raises TypeError do
      GeoIP.num_to_addr(nil)
    end
    assert_raises TypeError do
      GeoIP.num_to_addr("foo.bar")
    end
  end
end

