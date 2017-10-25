# frozen_string_literal: true
# encoding: UTF-8

module GeoIP
  class Domain
    include GeoIP::Base
    include GeoIP::Tools

    def initialize(*args)
      initialize_geoip(*args)
    end

    def look_up(addr)
      addr = value_to_addr(addr)
      check_type(addr, String)

      fix_encoding(:domain => FFIGeoIP.GeoIP_name_by_addr(@ptr, addr))
    end
  end
end

