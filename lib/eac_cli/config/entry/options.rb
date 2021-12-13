# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Config < ::SimpleDelegator
    class Entry
      class Options
        enable_simple_cache
        enable_listable

        lists.add_symbol :type, :undefined

        DEFAULT_VALUES = {
          before_input: nil, bool: false, list: false, noecho: false, noenv: false, noinput: false,
          required: true, store: true, type: TYPE_UNDEFINED, validator: nil
        }.freeze

        lists.add_symbol :option, *DEFAULT_VALUES.keys

        common_constructor :options do
          self.options = self.class.lists.option.hash_keys_validate!(options)
        end

        delegate :to_h, to: :options

        def [](key)
          values.fetch(key.to_sym)
        end

        def request_input_options
          values.slice(:bool, :list, :noecho)
        end

        DEFAULT_VALUES.each do |attr, default_value|
          define_method(attr.to_s + ([true, false].include?(default_value) ? '?' : '')) do
            self[attr]
          end
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
end
