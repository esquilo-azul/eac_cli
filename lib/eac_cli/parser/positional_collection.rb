# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_cli/parser/error'

module EacCli
  class Parser
    class PositionalCollection
      common_constructor(:definition, :argv, :collector) { collect }

      private

      def collected
        @collected ||= ::Set.new
      end

      def collect
        argv.each { |argv_value| collect_argv_value(argv_value) }
        return unless positional_pending?

        raise ::EacCli::Parser::Error.new(
          definition, argv, 'No value for required positional ' \
            "\"#{positional_enum.current.identifier}\""
        )
      end

      def collect_argv_value(argv_value)
        collector.collect(positional_enum.peek, argv_value)
        collected << positional_enum.peek
        positional_enum.next unless positional_enum.peek.repeat?
      end

      def positional_enum
        @positional_enum ||= definition.positional.each
      end

      def positional_pending?
        !(positional_enum.stopped? || positional_enum.current.optional? ||
            collected.include?(positional_enum.current))
      end
    end
  end
end
