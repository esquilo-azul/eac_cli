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
        argv.each { |argv_value| colect_argv_value(argv_value) }
        return unless pending_required_positional?

        raise ::EacCli::Parser::Error.new(
          definition, argv, 'No value for required positional ' \
            "\"#{current_positional.identifier}\""
        )
      end

      def colect_argv_value(argv_value)
        collector.collect(current_positional, argv_value)
        collected << current_positional
        positional_enumerator.next unless current_positional.repeat?
      end

      def pending_required_positional?
        !(current_positional.blank? || current_positional.optional? ||
            collected.include?(current_positional))
      end

      def positional_enumerator
        @positional_enumerator ||= definition.positional.each
      end

      def current_positional
        positional_enumerator.peek
      rescue ::StopIteration
        nil
      end
    end
  end
end
