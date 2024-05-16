# frozen_string_literal: true

require 'active_support/hash_with_indifferent_access'
require 'ostruct'

module EacCli
  class Speaker
    class List
      VALUE_STRUCT = ::Struct.new(:key, :label, :value)

      class << self
        def build(list)
          return List.new(hash_to_values(list)) if list.is_a?(::Hash)
          return List.new(array_to_values(list)) if list.is_a?(::Array)

          raise "Invalid list: #{list} (#{list.class})"
        end

        private

        def hash_to_values(list)
          list.map { |key, value| VALUE_STRUCT.new(key, key, value) }
        end

        def array_to_values(list)
          list.map { |value| VALUE_STRUCT.new(value, value, value) }
        end
      end

      # @!attribute [r] values
      #   @return [Array<VALUE_STRUCT>]
      # @!method initialize(values)
      #   @param values [Array<VALUE_STRUCT>]
      common_constructor :values do
        self.values = values.map do |v|
          VALUE_STRUCT.new(to_key(v.key), to_label(v.label), v.value)
        end
      end

      def valid_labels
        values.map(&:label)
      end

      def valid_value?(value)
        values.any? { |v| v.key == to_key(value) }
      end

      def to_key(value)
        to_label(value).downcase
      end

      def to_label(value)
        value.to_s.strip
      end

      def build_value(value)
        key = to_key(value)
        values.each do |v|
          return v.value if v.key == key
        end
        raise "Value not found: \"#{value}\" (#{values})"
      end
    end
  end
end
