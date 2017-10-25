# frozen_string_literal: true
# encoding: UTF-8

module GeoIP
  class Record < FFI::Struct
    include Tools

    layout(
      :country_code,    :string,
      :country_code3,   :string,
      :country_name,    :string,
      :region,          :string,
      :city,            :string,
      :postal_code,     :string,
      :latitude,        :float,
      :longitude,       :float,
      :dma_code,        :int,
      :area_code,       :int,
      :charset,         :int,
      :continent_code,  :string,
      :country_conf,    :uchar,
      :region_conf,     :uchar,
      :city_conf,       :uchar,
      :postal_conf,     :uchar,
      :accuracy_radius, :int
    )

    HASH_KEYS = [
      :country_code,
      :country_code3,
      :country_name,
      :region,
      :city,
      :postal_code,
      :latitude,
      :longitude,
      :dma_code,
      :area_code
    ].freeze

    def to_h
      hash = HASH_KEYS.each_with_object({}) do |key, memo|
        memo[key] = self[key] unless self[key].nil?
      end

      if self[:region]
        hash[:region_name] = FFIGeoIP.GeoIP_region_name_by_code(self[:country_code], self[:region])
      end

      fix_encoding(hash)
    end
  end
end

