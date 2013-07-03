# encoding: UTF-8

module GeoIP
  class Country
    include GeoIP::Base
    include GeoIP::Tools

    def initialize(*args)
      initialize_geoip(*args)
    end

    def look_up(addr)
      addr = value_to_addr(addr)
      check_type(addr, String)

      fix_encoding(
        :country_code => FFIGeoIP.GeoIP_country_code_by_addr(@ptr, addr),
        :country_code3 => FFIGeoIP.GeoIP_country_code3_by_addr(@ptr, addr),
        :country_name => FFIGeoIP.GeoIP_country_name_by_addr(@ptr, addr)
      )
    end
  end
end

