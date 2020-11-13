# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_cli/parser/error'

module EacCli
  class Parser
    class PositionalCollection
      common_constructor(:definition, :argv, :collector) { collect }

      private

      def argv_enum
        @argv_enum ||= argv.each
      end

      def argv_pending?
        argv_enum.ongoing?
      end

      def argv_pending_check
        return unless argv_pending?
        return unless positional_enum.stopped?

        raise ::EacCli::Parser::Error.new(
          definition, argv, "No positional left for argv \"#{argv_enum.current}\""
        )
      end

      def collected
        @collected ||= ::Set.new
      end

      def collect
        loop do
          break unless enums('pending?').any?

          enums('pending_check')
          collect_argv_value
        end
      end

      def collect_argv_value
        collector.collect(*enums('enum', &:peek))
        collected << positional_enum.peek
        positional_enum.next unless positional_enum.peek.repeat?
        argv_enum.next
      end

      def enums(method_suffix, &block)
        %w[positional argv].map do |method_prefix|
          v = send("#{method_prefix}_#{method_suffix}")
          block ? block.call(v) : v
        end
      end

      def positional_enum
        @positional_enum ||= definition.positional.each
      end

      def positional_pending?
        !(positional_enum.stopped? || positional_enum.current.optional? ||
            collected.include?(positional_enum.current))
      end

      def positional_pending_check
        return unless positional_pending?
        return unless argv_enum.stopped?

        raise ::EacCli::Parser::Error.new(
          definition, argv, 'No value for required positional ' \
            "\"#{positional_enum.current.identifier}\""
        )
      end
    end
  end
end
