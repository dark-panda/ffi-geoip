# encoding: UTF-8

module GeoIP
  class City
    include GeoIP::Base
    include GeoIP::Tools

    def initialize(*args)
      initialize_geoip(*args)
    end

    def look_up(addr)
      addr = value_to_addr(addr)
      check_type(addr, String)

      record = Record.new(FFIGeoIP.GeoIP_record_by_addr(@ptr, addr))

      if !record.null?
        hash = record.to_h
        FFIGeoIP.GeoIPRecord_delete(record)
        hash
      end
    end
  end
end

