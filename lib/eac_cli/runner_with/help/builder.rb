# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  module RunnerWith
    module Help
      class Builder
        require_sub __FILE__
        common_constructor :definition

        SEP = ' '
        IDENT = SEP * 2
        OPTION_DESC_SEP = IDENT * 2

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
              [option.short, option_long(option)].reject(&:blank?).join(SEP)
            else
              option_short(option)
            end
          end
        end

        def option_definition(option)
          [self.class.option_usage_full(option), option.description,
           option.default_value? ? "[Default: \"#{option.default_value}\"]" : nil]
            .reject(&:blank?).join(OPTION_DESC_SEP)
        end

        def section(header, include_header = true)
          b = include_header ? "#{header.humanize}:\n" : ''
          b += send("self_#{header}") + "\n"
          definition.alternatives.each do |alternative|
            b += IDENT + ::EacCli::RunnerWith::Help::Builder::Alternative.new(alternative).to_s +
                 "\n"
          end
          b
        end

        def options_section
          "Options:\n" +
            definition.alternatives.flat_map(&:options)
                      .map { |option| IDENT + option_definition(option) + "\n" }.join
        end

        def usage_section
          "Usage:\n" +
            definition.alternatives.map do |alternative|
              IDENT + ::EacCli::RunnerWith::Help::Builder::Alternative.new(alternative).to_s + "\n"
            end.join
        end

        def to_s
          "#{definition.description}\n\n#{usage_section}\n#{options_section}\n"
        end
      end
    end
  end
end
