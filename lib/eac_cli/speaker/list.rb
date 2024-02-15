# frozen_string_literal: true

require 'active_support/hash_with_indifferent_access'
require 'ostruct'

module EacCli
  class Speaker
    class List
      class << self
        def build(list)
          return List.new(hash_to_values(list)) if list.is_a?(::Hash)
          return List.new(array_to_values(list)) if list.is_a?(::Array)

          raise "Invalid list: #{list} (#{list.class})"
        end

        private

        def hash_to_values(list)
          list.map { |key, value| ::OpenStruct.new(key: key, label: key, value: value) } # rubocop:disable Style/OpenStructUse
        end

        def array_to_values(list)
          list.map { |value| ::OpenStruct.new(key: value, label: value, value: value) }  # rubocop:disable Style/OpenStructUse
        end
      end

      attr_reader :values

      def initialize(values)
        @values = values.map do |v|
          ::OpenStruct.new(key: to_key(v.key), label: to_label(v.label), value: v.value) # rubocop:disable Style/OpenStructUse
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
