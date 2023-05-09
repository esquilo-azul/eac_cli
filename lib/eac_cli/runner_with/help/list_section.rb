# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  module RunnerWith
    module Help
      class ListSection
        WORD_SEPARATOR = ' '
        IDENTATION = WORD_SEPARATOR * 2

        common_constructor :title, :items

        # @return [String]
        def to_s
          (["#{title}:"] + items.map { |line| "#{IDENTATION}#{line}" })
            .map { |line| "#{line}\n" }.join
        end
      end
    end
  end
end
