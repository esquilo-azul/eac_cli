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
        return for_all_answers.fetch(message) if for_all_answers.key?(message)
        return false if parsed.no?
        return true if parsed.yes?

        r = confirm_input(message)
        for_all_answers[message] = r.for_all?
        r.confirm?
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

      # @param message [String, nil]
      # @return [Boolean]
      def confirm_input(message)
        ::EacCli::RunnerWith::Confirmation::InputResult.by_message(
          message || setting_value(:confirm_question_text, default: DEFAULT_CONFIRM_QUESTION_TEXT)
        )
      end

      # @return [Hash<String, Boolean>]
      def for_all_answers_uncached
        {}
      end

      require_sub __FILE__
    end
  end
end
