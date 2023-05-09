# frozen_string_literal: true

require 'eac_cli/runner_with/help/list_section'
require 'eac_ruby_utils/core_ext'

module EacCli
  module RunnerWith
    module Help
      class Builder
        require_sub __FILE__, require_dependency: true
        common_constructor :runner

        OPTION_DESC_SEP = ::EacCli::RunnerWith::Help::ListSection::IDENTATION * 2
        SECTION_SEPARATOR = "\n"

        class << self
          def option_long(option)
            b = option.long
            b += '=<value>' if option.argument?
            b
          end

          def option_short(option)
            b = option.short
            b += '=<value>' if option.argument?
            b
          end

          def option_usage_full(option)
            if option.long.present?
              [option.short, option_long(option)].reject(&:blank?).join(word_separator)
            else
              option_short(option)
            end
          end

          def word_separator
            ::EacCli::RunnerWith::Help::ListSection::WORD_SEPARATOR
          end
        end

        delegate :word_separator, to: :class

        def definition
          runner.class.runner_definition
        end

        def option_definition(option)
          [self.class.option_usage_full(option), option.description,
           option.default_value? ? "[Default: \"#{option.default_value}\"]" : nil]
            .reject(&:blank?).join(OPTION_DESC_SEP)
        end

        # @return [String]
        def options_section
          ::EacCli::RunnerWith::Help::ListSection.new(
            'Options',
            definition.alternatives.flat_map(&:options).map { |option| option_definition(option) }
          )
        end

        # @return [String]
        def usage_section
          ::EacCli::RunnerWith::Help::ListSection.new(
            'Usage',
            definition.alternatives.map { |alternative| self.alternative(alternative) }
          )
        end

        def to_s
          ["#{definition.description}\n", usage_section, options_section]
            .map { |s| "#{s}#{SECTION_SEPARATOR}" }.join
        end
      end
    end
  end
end
