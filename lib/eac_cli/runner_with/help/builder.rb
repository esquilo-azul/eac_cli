# frozen_string_literal: true

require 'eac_cli/runner_with/help/layout'
require 'eac_ruby_utils/core_ext'

module EacCli
  module RunnerWith
    module Help
      class Builder
        include ::EacCli::RunnerWith::Help::Layout
        require_sub __FILE__, require_dependency: true
        common_constructor :runner

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
            WORD_SEPARATOR
          end
        end

        delegate :word_separator, to: :class

        def definition
          runner.class.runner_definition
        end

        # @return [String, nil]
        def extra_section
          ess = extra_sections
          return nil if ess.none?

          ess.join(SECTION_SEPARATOR)
        end

        # @return [Enumerable<String>]
        def extra_sections
          runner.if_respond(:help_extra_text, []) do |v|
            if v.is_a?(::Hash)
              v.map do |title, lines|
                list_section(title, lines)
              end
            else
              [v.to_s]
            end
          end
        end

        def option_definition(option)
          [self.class.option_usage_full(option), option.description,
           option.default_value? ? "[Default: \"#{option.default_value}\"]" : nil]
            .reject(&:blank?).join(OPTION_DESCRIPTION_SEPARATOR)
        end

        # @return [String]
        def options_section
          list_section(
            'Options',
            definition.alternatives.flat_map(&:options).map { |option| option_definition(option) }
          )
        end

        # @return [String]
        def usage_section
          list_section(
            'Usage',
            definition.alternatives.map { |alternative| self.alternative(alternative) }
          )
        end

        def to_s
          r = ["#{definition.description}\n", usage_section, options_section]
                .map { |s| "#{s}#{SECTION_SEPARATOR}" }.join
          extra_section.if_present(r) { |v| r + v }
        end
      end
    end
  end
end
