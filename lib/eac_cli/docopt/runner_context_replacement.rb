# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  module Docopt
    class RunnerContextReplacement
      common_constructor :runner

      def argv
        runner.settings[:argv] || ARGV
      end
    end
  end
end
