# encoding: UTF-8

$: << File.dirname(__FILE__)
require 'test_helper'

class GeoIPOrganizationTest < MiniTest::Unit::TestCase
  ORGANIZATION = {
    :name => "AT&T Worldnet Services"
  }

  ORGANIZATION_IP = '12.87.118.0'

  def assert_look_up(db, expected = ORGANIZATION, lookup = ORGANIZATION_IP)
    hash = db.look_up(lookup)
    assert_kind_of(Hash, hash)
    assert_equal(expected, hash)
  end

  def test_construction_default
    db = GeoIP::ISP.new(ISP_DB)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_default
    db = GeoIP::Organization.new(ORG_DB)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_index
    db = GeoIP::Organization.new(ORG_DB, :index)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_filesystem
    db = GeoIP::Organization.new(ORG_DB, :filesystem)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_memory
    db = GeoIP::Organization.new(ORG_DB, :memory)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_filesystem_check
    db = GeoIP::Organization.new(ORG_DB, :filesystem, true)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_bad_db_file
    assert_raises(Errno::ENOENT) do
      GeoIP::Organization.new('/supposed-to-fail')
    end
  end
end

