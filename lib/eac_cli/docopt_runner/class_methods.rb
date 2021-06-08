# frozen_string_literal: true

require 'docopt'

module EacCli
  class DocoptRunner
    module ClassMethods
      DOCOPT_ERROR_EXIT_CODE = 0xC0

      def run(options = {})
        create(options).send(:run)
      rescue ::Docopt::Exit => e
        STDERR.write(e.message + "\n")
        ::Kernel.exit(DOCOPT_ERROR_EXIT_CODE)
      end
    end
  end
end
