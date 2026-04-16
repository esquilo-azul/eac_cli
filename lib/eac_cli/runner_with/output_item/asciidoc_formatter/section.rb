# frozen_string_literal: true

module EacCli
  module RunnerWith
    module OutputItem
      class AsciidocFormatter < ::EacCli::RunnerWith::OutputItem::BaseFormatter
        class Section
          acts_as_instance_method
          common_constructor :caller, :title, :content, :level

          # @return [String]
          def result
            "#{formatted_title}\n\n#{formatted_content}"
          end

          protected

          # @return [String]
          def formatted_title
            "#{'=' * level} #{title}"
          end

          # @return [String]
          def formatted_content
            caller.send(:output_object, content, level)
          end
        end
      end
    end
  end
end
