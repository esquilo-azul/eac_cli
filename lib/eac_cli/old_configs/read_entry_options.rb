# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class OldConfigs
    class ReadEntryOptions
      enable_simple_cache
      common_constructor :options do
        self.options = options.to_h.symbolize_keys
                              .assert_valid_keys(DEFAULT_VALUES.keys).freeze
      end

      DEFAULT_VALUES = {
        before_input: nil, bool: false, list: false, noecho: false, noenv: false, noinput: false,
        required: true, store: true, validator: nil
      }.freeze

      delegate :to_h, to: :options

      def [](key)
        values.fetch(key.to_sym)
      end

      def request_input_options
        values.slice(:bool, :list, :noecho)
      end

      private

      def values_uncached
        consumer = options.to_options_consumer
        r = {}
        DEFAULT_VALUES.each do |key, default_value|
          value = consumer.consume(key)
          value = default_value if value.nil?
          r[key] = value
        end
        consumer.validate
        r
      end
    end
  end
end
