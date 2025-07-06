# frozen_string_literal: true

require 'yaml'

module EacCli
  module RunnerWith
    module OutputItem
      class AsciidocFormatter < ::EacCli::RunnerWith::OutputItem::BaseFormatter
        STARTING_LEVEL = 2

        # @return [String]
        def to_output
          output_hash(item_hash, STARTING_LEVEL)
        end

        protected

        # @param hash [Hash]
        # @param level [Integer]
        # @return [String]
        def output_enumerable(enumerable, level)
          enumerable.map { |e| output_object(e, level + 1) }.join
        end

        # @param hash [Hash]
        # @param level [Integer]
        # @return [String]
        def output_hash(hash, level)
          hash.map { |k, v| section(k, v, level) }.join("\n")
        end

        def output_object(object, level)
          return output_hash(object, level) if object.is_a?(::Hash)
          return output_enumerable(object, level) if object.is_a?(::Enumerable)

          output_string(object, level)
        end

        # @param string [String]
        # @param level [Integer]
        # @return [String]
        def output_string(string, _level)
          "* #{string.to_s.strip}\n"
        end

        # @param title [String]
        # @param content [String]
        # @param level [Integer]
        # @return [String]
        def section(title, content, level)
          "#{section_title(title, level)}\n\n#{section_content(content, level)}"
        end

        # @param title [String]
        # @param level [Integer]
        # @return [String]
        def section_title(title, level)
          "#{'=' * level} #{title}"
        end

        # @param content [String]
        # @param level [Integer]
        # @return [String]
        def section_content(content, level)
          output_object(content, level)
        end
      end
    end
  end
end
