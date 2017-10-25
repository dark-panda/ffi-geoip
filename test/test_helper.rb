# encoding: UTF-8

if RUBY_VERSION >= '1.9'
  require 'simplecov'

  SimpleCov.command_name('Unit Tests')
  SimpleCov.merge_timeout(3600)
  SimpleCov.start do
    add_filter '/test/'
  end
end

require 'rubygems'
require 'minitest/autorun'
require 'minitest/reporters' if RUBY_VERSION >= '1.9'

if ENV['USE_BINARY']
  Object.send(:remove_const, :GeoIP)
  require 'geoip'
else
  require File.join(File.dirname(__FILE__), %w{ .. lib ffi-geoip })
end

puts "Ruby version #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} - #{RbConfig::CONFIG['RUBY_INSTALL_NAME']}"
puts "ffi version #{Gem.loaded_specs['ffi'].version}" if Gem.loaded_specs['ffi']
puts "ffi-geoip version #{GeoIP::VERSION}" if defined?(GeoIP::VERSION)
puts "GeoIP version #{GeoIP.version}" if GeoIP.respond_to?(:version)

TEST_DIR = File.dirname(__FILE__)
DATA_DIR = File.join(TEST_DIR, 'data')

COUNTRY_DB = ENV.fetch('COUNTRY', File.join(DATA_DIR, 'GeoIP.dat'))
CITY_DB = ENV.fetch('CITY', File.join(DATA_DIR, 'GeoIPCity.dat'))
ISP_DB = ENV.fetch('ISP',  File.join(DATA_DIR, 'GeoIPISP.dat'))
ORG_DB = ENV.fetch('ORG',  File.join(DATA_DIR, 'GeoIPOrg.dat'))
DOMAIN_DB = ENV.fetch('DOMAIN',  File.join(DATA_DIR, 'GeoIPDomain.dat'))
NETSPEED_DB = ENV.fetch('NETSPEED',  File.join(DATA_DIR, 'GeoIPNetSpeedCell.dat'))

if RUBY_VERSION >= '1.9'
  Minitest::Reporters.use!(MiniTest::Reporters::SpecReporter.new)
end

class Minitest::Test
  def assert_look_up(db, addr, field, value)
    h = db.look_up(addr)
    assert_equal value, h[field]
    h
  end

  def assert_raises_type_error(db)
    assert_raises(TypeError) do
      db.look_up(nil)
    end
  end
end
