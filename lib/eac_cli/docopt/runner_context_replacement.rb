# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  module Docopt
    class RunnerContextReplacement
      common_constructor :runner

      def argv
        runner.settings[:argv] || ARGV
      end

      def program_name
        runner.settings[:program_name] || $PROGRAM_NAME
      end
    end
  end
end
