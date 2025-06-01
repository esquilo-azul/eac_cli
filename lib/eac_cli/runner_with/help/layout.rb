# frozen_string_literal: true

require 'eac_ruby_utils'

module EacCli
  module RunnerWith
    module Help
      module Layout
        common_concern do
          include InstanceClassMethods
          extend InstanceClassMethods
        end

        module InstanceClassMethods
          WORD_SEPARATOR = ' '
          IDENTATION = WORD_SEPARATOR * 2
          OPTION_DESCRIPTION_SEPARATOR = IDENTATION * 2
          LINE_BREAK = "\n"
          SECTION_SEPARATOR = LINE_BREAK * 2

          # @param title String
          # @param items [Enumerable<String>]
          # @return [String]
          def list_section(title, items)
            (["#{title}:"] + items.map { |line| "#{IDENTATION}#{line}" })
              .map { |line| "#{line}\n" }.join
          end

          # @param sections [Enumerable<String>]
          # @return [String]
          def join_sections(*sections)
            sections.map { |s| s.to_s.strip }.join(SECTION_SEPARATOR) + LINE_BREAK
          end
        end

        extend InstanceClassMethods
      end
    end
  end
end
