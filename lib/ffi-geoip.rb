# encoding: UTF-8

require 'ffi'
require 'rbconfig'
require 'ffi-geoip/version'

module GeoIP
  GEOIP_BASE = File.join(File.dirname(__FILE__), 'ffi-geoip')

  autoload :Base,
    File.join(GEOIP_BASE, 'base')

  autoload :City,
    File.join(GEOIP_BASE, 'city')

  autoload :Country,
    File.join(GEOIP_BASE, 'country')

  autoload :Organization,
    File.join(GEOIP_BASE, 'organization')

  autoload :ISP,
    File.join(GEOIP_BASE, 'isp')

  autoload :NetSpeed,
    File.join(GEOIP_BASE, 'netspeed')

  autoload :Domain,
    File.join(GEOIP_BASE, 'domain')

  autoload :Tools,
    File.join(GEOIP_BASE, 'tools')

  autoload :Record,
    File.join(GEOIP_BASE, 'record')

  module FFIGeoIP
    def self.search_paths
      @search_paths ||= begin
        if ENV['GEOIP_LIBRARY_PATH']
          [ ENV['GEOIP_LIBRARY_PATH'] ]
        elsif FFI::Platform::IS_WINDOWS
          ENV['PATH'].split(File::PATH_SEPARATOR)
        else
          [ '/usr/local/{lib64,lib}', '/opt/local/{lib64,lib}', '/usr/{lib64,lib}' ]
          [ '/usr/local/{lib64,lib}', '/opt/local/{lib64,lib}', '/usr/{lib64,lib}', '/usr/lib/{x86_64,i386}-linux-gnu' ]
        end
      end
    end

    def self.find_lib(lib)
      if ENV['GEOIP_LIBRARY_PATH'] && File.file?(ENV['GEOIP_LIBRARY_PATH'])
        ENV['GEOIP_LIBRARY_PATH']
      else
        Dir.glob(search_paths.map { |path|
          File.expand_path(File.join(path, "#{lib}.#{FFI::Platform::LIBSUFFIX}"))
        }).first
      end
    end

    def self.geoip_library_path
      @geoip_library_path ||= begin
        # On MingW the libraries have version numbers
        find_lib('{lib,}GeoIP{,-?}')
      end
    end

    extend ::FFI::Library

    GeoIP::GeoIPOptions = enum(:geoip_option, [
      :standard, 0,
      :memory_cache, 1,
      :check_cache, 2,
      :index_cache, 4,
      :mmap_cache, 8
    ])

    FFI_LAYOUT = {
      :GeoIP_open => [
        # GeoIP*, filename, flags
        :pointer, :string, :int
      ],

      :GeoIP_delete => [
        # void, GeoIP*
        :void, :pointer
      ],

      #### countries ####
      # string, GeoIP*, addr
      :GeoIP_country_code_by_addr => [
        :string, :pointer, :string
      ],

      # string, GeoIP*, host
      :GeoIP_country_code_by_name => [
        :string, :pointer, :string
      ],

      # string, GeoIP*, addr
      :GeoIP_country_code3_by_addr => [
        :string, :pointer, :string
      ],

      # string, GeoIP*, host
      :GeoIP_country_code3_by_name => [
        :string, :pointer, :string
      ],

      # string, GeoIP*, addr
      :GeoIP_country_name_by_addr => [
        :string, :pointer, :string
      ],

      # string, GeoIP*, host
      :GeoIP_country_name_by_name => [
        :string, :pointer, :string
      ],

      # string, GeoIP*, ipnum
      :GeoIP_country_name_by_ipnum => [
        :string, :pointer, :ulong
      ],

      # string, GeoIP*, ipnum
      :GeoIP_country_code_by_ipnum => [
        :string, :pointer, :ulong
      ],

      # string, GeoIP*, ipnum
      :GeoIP_country_code3_by_ipnum => [
        :string, :pointer, :ulong
      ],

      # # string, GeoIP*, geoipv6_t ipnum
      # :GeoIP_country_name_by_ipnum_v6 => [
      #   :string, :pointer, :geoipv6_t
      # ],
      # # string, GeoIP*, geoipv6_t ipnum
      # :GeoIP_country_code_by_ipnum_v6 => [
      #   :string, :pointer, :geoipv6_t
      # ],
      # # string, GeoIP*, geoipv6_t ipnum
      # :GeoIP_country_code3_by_ipnum_v6 => [
      #   :string, :pointer, :geoipv6_t
      # ],

      # string, GeoIP*, addr
      :GeoIP_country_code_by_addr_v6 => [
        :string, :pointer, :string
      ],

      # string, GeoIP*, host
      :GeoIP_country_code_by_name_v6 => [
        :string, :pointer, :string
      ],

      # string, GeoIP*, addr
      :GeoIP_country_code3_by_addr_v6 => [
        :string, :pointer, :string
      ],

      # string, GeoIP*, host
      :GeoIP_country_code3_by_name_v6 => [
        :string, :pointer, :string
      ],

      # string, GeoIP*, addr
      :GeoIP_country_name_by_addr_v6 => [
        :string, :pointer, :string
      ],

      # string, GeoIP*, host
      :GeoIP_country_name_by_name_v6 => [
        :string, :pointer, :string
      ],
      #### /countries ####

      #### IDs ####
      # id, GeoIP*, addr
      :GeoIP_id_by_addr => [
        :int, :pointer, :string
      ],

      # id, GeoIP*, host
      :GeoIP_id_by_name => [
        :int, :pointer, :string
      ],

      # id, GeoIP*, ipnum
      :GeoIP_id_by_ipnum => [
        :int, :pointer, :ulong
      ],

      # id, GeoIP*, addr
      :GeoIP_id_by_addr_v6 => [
        :int, :pointer, :string
      ],

      # id, GeoIP*, host
      :GeoIP_id_by_name_v6 => [
        :int, :pointer, :string
      ],

      # # id, GeoIP*, ipnum
      # :GeoIP_id_by_ipnum_v6 => [
      #   :int, :pointer, :geoipv6_t
      # ],
      #### /IDs ####

      #### regions ####
      # GeoIPRegion*, GeoIP*, addr
      :GeoIP_region_by_addr => [
        :pointer, :pointer, :string
      ],

      # GeoIPRegion*, GeoIP*, host
      :GeoIP_region_by_name => [
        :pointer, :pointer, :string
      ],

      # GeoIPRegion*, GeoIP*, ipnum
      :GeoIP_region_by_ipnum => [
        :pointer, :pointer, :ulong
      ],

      # GeoIPRegion*, GeoIP*, addr
      :GeoIP_region_by_addr_v6 => [
        :pointer, :pointer, :string
      ],

      # GeoIPRegion*, GeoIP*, host
      :GeoIP_region_by_name_v6 => [
        :pointer, :pointer, :string
      ],

      # # GeoIPRegion*, GeoIP*, ipnum
      # :GeoIP_region_by_ipnum_v6 => [
      #   :pointer, :pointer, :geoipv6_t
      # ],

      # void, GeoIPRegion*
      :GeoIPRegion_delete => [
        :void, :pointer
      ],
      #### /region

      #### organization names ####
      # name, GeoIP*, ipnum
      :GeoIP_name_by_ipnum => [
        :string, :pointer, :ulong
      ],
      # name, GeoIP*, addr
      :GeoIP_name_by_addr => [
        :string, :pointer, :string
      ],
      # name, GeoIP*, host
      :GeoIP_name_by_name => [
        :string, :pointer, :string
      ],

      # # name, GeoIP*, ipnum
      # :GeoIP_name_by_ipnum_v6 => [
      #   :string, :pointer, :geoipv6_t
      # ],

      # name, GeoIP*, addr
      :GeoIP_name_by_addr_v6 => [
        :string, :pointer, :string
      ],
      # name, GeoIP*, host
      :GeoIP_name_by_name_v6 => [
        :string, :pointer, :string
      ],
      #### /organization names ####

      #### fetch by IDs ####
      # string, id
      :GeoIP_code_by_id => [
        :string, :int
      ],

      # string, id
      :GeoIP_code3_by_id => [
        :string, :int
      ],

      # string, GeoIP*, id
      :GeoIP_country_name_by_id => [
        :string, :pointer, :int
      ],

      # string, id
      :GeoIP_name_by_id => [
        :string, :int
      ],

      # string, id
      :GeoIP_continent_by_id => [
        :string, :int
      ],

      # id, country
      :GeoIP_id_by_code => [
        :int, :string
      ],
      #### /fetch by IDs ####

      #### full city records ####
      # GeoIPRecord*, GeoIP*, ipnum
      :GeoIP_record_by_ipnum => [
        GeoIP::Record, :pointer, :ulong
      ],

      # GeoIPRecord*, GeoIP*, addr
      :GeoIP_record_by_addr => [
        GeoIP::Record, :pointer, :string
      ],

      # GeoIPRecord*, GeoIP*, host
      :GeoIP_record_by_name => [
        GeoIP::Record, :pointer, :string
      ],

      # # GeoIPRecord*, GeoIP*, geoipv6_t ipnum
      # :GeoIP_record_by_ipnum_v6 => [
      #   :pointer, :pointer, :geoipv6_t
      # ],

      # GeoIPRecord*, GeoIP*, addr
      :GeoIP_record_by_addr_v6 => [
        GeoIP::Record, :pointer, :string
      ],

      # GeoIPRecord*, GeoIP*, host
      :GeoIP_record_by_name_v6 => [
        GeoIP::Record, :pointer, :string
      ],

      # record ID, GeoIP*, addr
      :GeoIP_record_id_by_addr => [
        :int, :pointer, :string
      ],

      # record ID, GeoIP*, string
      :GeoIP_record_id_by_addr_v6 => [
        :int, :pointer, :string
      ],

      # void, GeoIPRecord*
      :GeoIPRecord_delete => [
        :void, GeoIP::Record
      ],
      #### /full record

      #### utility functions ####
      # num, void
      :GeoIP_num_countries => [
        :uint
      ],

      # info, GeoIP*
      :GeoIP_database_info => [
        :string, :pointer
      ],

      # edition, GeoIP*
      :GeoIP_database_edition => [
        :uchar, :pointer
      ],

      # int, GeoIP*
      :GeoIP_charset => [
        :int, :pointer
      ],

      # int, GeoIP*, charset
      :GeoIP_set_charset => [
        :int, :pointer, :int
      ],

      # int, GeoIP*, true/false
      :GeoIP_enable_teredo => [
        :int, :pointer, :int
      ],

      # int, GeoIP*
      :GeoIP_teredo => [
        :int, :pointer
      ],

      # int, GeoIP*
      :GeoIP_last_netmask => [
        :int, :pointer
      ],

      # char**, GeoIP*, addr
      :GeoIP_range_by_ip => [
        :pointer, :pointer, :string
      ],

      # ipnum, addr
      :GeoIP_addr_to_num => [
        :ulong, :string
      ],

      # addr, ipnum
      :GeoIP_num_to_addr => [
        :string, :ulong
      ],
      #### /utility functions ####

      #### region code ####
      # string, country_code, region_code
      :GeoIP_region_name_by_code => [
        :string, :string, :string
      ],
      #### /region code ####

      #### time zone ####
      # string, country_code, region_code
      :GeoIP_time_zone_by_country_and_region => [
        :string, :string, :string
      ],
      #### /time zone ####

      # string, void
      :GeoIP_lib_version => [
        :string
      ]
    }

    begin
      ffi_lib(geoip_library_path)

      FFI_LAYOUT.each do |fun, ary|
        ret = ary.shift
        begin
          self.class_eval do
            attach_function(fun, ary, ret)
          end
        rescue FFI::NotFoundError
          # that's okay
        end
      end

    rescue LoadError, NoMethodError
      raise LoadError.new("Couldn't load the GeoIP library.")
    end
  end

  class << self
    include GeoIP::Tools

    def version
      @version ||= FFIGeoIP.GeoIP_lib_version
    end

    def addr_to_num(addr)
      check_type(addr, String)
      FFIGeoIP.GeoIP_addr_to_num(addr)
    end

    def num_to_addr(num)
      check_type(num, Fixnum, Bignum)
      FFIGeoIP.GeoIP_num_to_addr(num)
    end
  end
end

