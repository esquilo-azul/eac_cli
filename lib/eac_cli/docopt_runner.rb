# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'docopt'

module EacCli
  class DocoptRunner
    require_sub __FILE__
    include ::EacCli::DocoptRunner::Context

    class << self
      def create(settings = {})
        new(settings)
      end
    end

    attr_reader :settings

    def initialize(settings = {})
      @settings = settings.with_indifferent_access.freeze
      check_subcommands
    end

    def options
      @options ||= ::Docopt.docopt(target_doc, docopt_options)
    end

    def parent
      settings[:parent]
    end

    protected

    def docopt_options
      settings.slice(:version, :argv, :help, :options_first).to_sym_keys_hash
    end
  end
end
