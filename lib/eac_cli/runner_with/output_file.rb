# frozen_string_literal: true

require 'eac_cli/runner'
require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/abstract_methods'

module EacCli
  module RunnerWith
    module OutputFile
      common_concern do
        include ::EacCli::Runner
        include ::EacRubyUtils::AbstractMethods

        abstract_methods :output_content

        runner_definition do
          arg_opt '-o', '--output-file', 'Output to file.'
        end
      end

      def run_output
        if parsed.output_file.present?
          ::File.write(parsed.output_file, output_content)
        else
          $stdout.write(output_content)
        end
      end
    end
  end
end
