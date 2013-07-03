# encoding: UTF-8

$: << File.dirname(__FILE__)
require 'test_helper'

class GeoIPCityTest < MiniTest::Unit::TestCase
  PITTSBURGH = {
    :country_code => "US",
    :country_code3 => "USA",
    :country_name => "United States",
    :region => "PA",
    :city => "Pittsburgh",
    :latitude => 40.44060134887695,
    :longitude => -79.99590301513672,
    :dma_code => 508,
    :area_code => 412,
    :region_name => "Pennsylvania"
  }

  PITTSBURGH_IP = '12.87.118.0'

  def assert_look_up(db, expected = PITTSBURGH, lookup = PITTSBURGH_IP)
    hash = db.look_up(lookup)
    assert_kind_of(Hash, hash)
    assert_equal(expected, hash)
  end

  def assert_raises_type_error(db)
    assert_raises(TypeError) do
      db.look_up(nil)
    end
  end

  def test_construction_default
    db = GeoIP::City.new(CITY_DB)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_index
    db = GeoIP::City.new(CITY_DB, :index)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_filesystem
    db = GeoIP::City.new(CITY_DB, :filesystem)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_memory
    db = GeoIP::City.new(CITY_DB, :memory)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_filesystem_check
    db = GeoIP::City.new(CITY_DB, :filesystem, true)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_bad_db_file
    assert_raises(Errno::ENOENT) do
      GeoIP::City.new('/supposed-to-fail')
    end
  end

  def test_character_encoding_converted_to_utf8_first
    db = GeoIP::City.new(CITY_DB, :filesystem, true)
    hash = db.look_up('89.160.20.112')
    assert_equal('UTF-8', hash[:city].encoding.to_s)
    assert_equal('Linköping', hash[:city])
  end
end

