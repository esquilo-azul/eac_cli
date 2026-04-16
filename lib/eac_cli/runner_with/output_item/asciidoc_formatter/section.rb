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
            "#{formatted_title}#{formatted_content}"
          end

          protected

          # @return [String]
          def formatted_title
            title.if_present('') { |_e| "#{'=' * level} #{title}\n\n" }
          end

          # @return [String]
          def formatted_content
            caller.send(:output_object, content, level + 1)
          end
        end
      end
    end
  end
end
