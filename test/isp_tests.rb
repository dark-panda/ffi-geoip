# frozen_string_literal: true
# encoding: UTF-8

$: << File.dirname(__FILE__)
require 'test_helper'

class GeoIPISPTest < Minitest::Test
  ISP = {
    :isp => "AT&T Services"
  }

  ISP_IP = '12.87.118.0'

  def assert_look_up(db, expected = ISP, lookup = ISP_IP)
    hash = db.look_up(lookup)
    assert_kind_of(Hash, hash)
    assert_equal(expected, hash)
  end

  def test_construction_default
    db = GeoIP::ISP.new(ISP_DB)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  # def test_construction_index
  #   db = GeoIP::ISP.new(ISP_DB, :index)
  #   assert_look_up(db, ISP_IP, :isp, 'Bell Aliant')
  # end

  def test_construction_filesystem
    db = GeoIP::ISP.new(ISP_DB, :filesystem)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_memory
    db = GeoIP::ISP.new(ISP_DB, :memory)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_construction_filesystem_check
    db = GeoIP::ISP.new(ISP_DB, :filesystem, true)
    assert_raises_type_error(db)
    assert_look_up(db)
  end

  def test_bad_db_file
    assert_raises Errno::ENOENT do
      GeoIP::ISP.new('/supposed-to-fail')
    end
  end
end

