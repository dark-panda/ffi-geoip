# frozen_string_literal: true
# encoding: UTF-8

module GeoIP
  module Tools
    private
      def check_enum_value(enum, value)
        enum[value] or
          raise TypeError.new("Couldn't find valid #{enum.tag} value: #{value}")
      end

      def check_type(value, *types)
        if !types.include?(value.class)
          type_names = types.collect(&:name).join(' or ')

          raise TypeError.new("wrong argument type #{value.class.name} (expected #{type_names})")
        end
      end

      def fix_encoding(hash)
        hash.each do |_, value|
          value.encode!('UTF-8', 'ISO-8859-1') if value.is_a?(String)
        end
      end
    end
end

