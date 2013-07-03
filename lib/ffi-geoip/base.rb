# encoding: UTF-8

module GeoIP
  module Base
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def release(ptr)
        FFIGeoIP.GeoIP_delete(ptr)
      end
    end

    def value_to_addr(value)
      case value
        when Numeric
          GeoIP.num_to_addr(value)

        when /^\d+\.\d+\.\d+\.\d+$/
          value
      end
    end

    private
      def initialize_geoip(file, load_option = nil, check_cache = nil)
        if load_option.nil?
          load_option = :memory
        end

        flags = check_load_option(load_option) or
          raise TypeError.new("the second option must be :memory, :filesystem, or :index")

        if check_cache
          flags |= GeoIPOptions[:check_cache]
        end

        if !File.exists?(file)
          raise enoent_exception
        else
          @ptr = FFI::AutoPointer.new(
            FFIGeoIP.GeoIP_open(file, flags),
            self.class.method(:release)
          )

          if @ptr.null?
            raise_enoent
          end
        end
      end

      def enoent_exception
        Errno::ENOENT.new("Problem opening database")
      end

      def check_load_option(load_option)
        case load_option
          when :memory
            GeoIP::GeoIPOptions[:memory_cache]
          when :filesystem
            GeoIP::GeoIPOptions[:standard]
          when :index
            GeoIP::GeoIPOptions[:index_cache]
        end
      end
  end
end

