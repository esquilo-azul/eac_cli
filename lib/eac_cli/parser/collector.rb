# frozen_string_literal: true

require 'eac_ruby_utils'

module EacCli
  class Parser
    class Collector
      class << self
        def to_data(definition)
          collector = new(definition)
          yield(collector)
          collector.to_data
        end
      end

      # @!method initialize(definition)
      # @param definition [EacCli::Definition]
      common_constructor :definition do
        default_values
      end

      # @return [EacRubyUtils::Struct]
      def to_data
        ::EacRubyUtils::Struct.new(data.transform_keys(&:identifier))
      end

      # @param option [EacCli::Definition::Option]
      # @param value [String]
      # @return [void]
      def collect(option, value)
        data[option] = option.build_value(value, data[option])
      end

      # @param option [EacCli::Definition::Option]
      # @return [Boolean]
      def supplied?(option)
        data[option].present?
      end

      private

      # @return [Hash]
      def data
        @data ||= {}
      end

      # @return [void]
      def default_values
        definition.options.each { |option| data[option] = option.default_value }
        definition.positional.each { |positional| data[positional] = positional.default_value }
      end
    end
  end
end
