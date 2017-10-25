# frozen_string_literal: true
# encoding: UTF-8

$: << File.dirname(__FILE__)
require 'test_helper'

class GeoIPDomainTest < Minitest::Test
  DOMAIN = {
    :domain => "shoesfin.NET"
  }

  DOMAIN_IP = '67.43.156.0'

  def assert_look_up(db, expected = DOMAIN, lookup = DOMAIN_IP)
    hash = db.look_up(lookup)
    assert_kind_of(Hash, hash)
    assert_equal(expected, hash)
  end

  def test_construction_default
    db = GeoIP::Domain.new(DOMAIN_DB)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_index
    db = GeoIP::Domain.new(DOMAIN_DB, :index)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_filesystem
    db = GeoIP::Domain.new(DOMAIN_DB, :filesystem)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_memory
    db = GeoIP::Domain.new(DOMAIN_DB, :memory)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_filesystem_check
    db = GeoIP::Domain.new(DOMAIN_DB, :filesystem, true)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_bad_db_file
    assert_raises(Errno::ENOENT) do
      GeoIP::Domain.new('/supposed-to-fail')
    end
  end
end

