# frozen_string_literal: true

require 'eac_cli/runner'
require 'eac_ruby_utils/core_ext'

module EacCli
  module RunnerWith
    module Confirmation
      DEFAULT_CONFIRM_QUESTION_TEXT = 'Confirm?'

      common_concern do
        include ::EacCli::Runner
        enable_settings_provider
        enable_simple_cache
        runner_definition do
          bool_opt '--no', 'Deny confirmation without question.'
          bool_opt '--yes', 'Accept confirmation without question.'
        end
      end

      def confirm?(message = nil)
        return false if parsed.no?
        return true if parsed.yes?

        confirm_input(message)
      rescue ::EacCli::Speaker::InputRequested => e
        fatal_error e.message
      end

      def run_confirm(message = nil)
        yield if confirm?(message)
      end

      private

      def cached_confirm_uncached?(message = nil)
        confirm?(message)
      end

      # @return [Boolean]
      def confirm_input(message)
        input(
          message || setting_value(:confirm_question_text, default: DEFAULT_CONFIRM_QUESTION_TEXT),
          bool: true
        )
      end

      require_sub __FILE__
    end
  end
end
