# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Config
    class Entry
      module Undefined
        private

        def undefined_value
          loop do
            entry_value = undefined_value_no_loop
            next unless options[:validator].if_present(true) { |v| v.call(entry_value) }

            return entry_value
          end
        end

        def undefined_value_no_loop
          input("Value for entry \"#{path}\"", options.request_input_options)
        end
      end
    end
  end
end
