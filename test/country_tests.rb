# frozen_string_literal: true
# encoding: UTF-8

$: << File.dirname(__FILE__)
require 'test_helper'

class GeoIPCountryTest < Minitest::Test
  UNITED_STATES = {
    :country_code => "US",
    :country_code3 => "USA",
    :country_name => "United States"
  }

  UNITED_STATES_IP = '12.87.118.0'

  def assert_look_up(db, expected = UNITED_STATES, lookup = UNITED_STATES_IP)
    hash = db.look_up(lookup)
    assert_kind_of(Hash, hash)
    assert_equal(expected, hash)
  end

  def test_construction_default
    db = GeoIP::Country.new(COUNTRY_DB)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_filesystem
    db = GeoIP::Country.new(COUNTRY_DB, :filesystem)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_memory
    db = GeoIP::Country.new(COUNTRY_DB, :memory)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_filesystem_check
    db = GeoIP::Country.new(COUNTRY_DB, :filesystem, true)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_bad_db_file
    assert_raises(Errno::ENOENT) do
      GeoIP::Country.new('/supposed-to-fail')
    end
  end
end

