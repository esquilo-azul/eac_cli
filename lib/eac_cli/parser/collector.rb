# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/struct'

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

      common_constructor :definition do
        default_values
      end

      # @return [OpenStruct]
      def to_data
        ::EacRubyUtils::Struct.new(data.transform_keys(&:identifier))
      end

      def collect(option, value)
        if data[option].is_a?(::Array)
          data[option] << value
        else
          data[option] = value
        end
      end

      def supplied?(option)
        data[option].present?
      end

      private

      def data
        @data ||= {}
      end

      def default_values
        definition.options.each { |option| data[option] = option.default_value }
        definition.positional.each { |positional| data[positional] = positional.default_value }
      end
    end
  end
end
