# frozen_string_literal: true

module EacCli
  class DocoptRunner
    DOCOPT_ERROR_EXIT_CODE = 0xC0

    class << self
      def run(options = {})
        create(options).send(:run)
      rescue Docopt::Exit => e
        STDERR.write(e.message + "\n")
        ::Kernel.exit(DOCOPT_ERROR_EXIT_CODE)
      end
    end
  end
end
