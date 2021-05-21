# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
require 'docopt'
require 'eac_ruby_utils/contextualizable'
require 'eac_ruby_utils/patches/hash/sym_keys_hash'
Dir["#{__dir__}/#{::File.basename(__FILE__, '.*')}/_*.rb"].sort.each do |partial|
  require partial
end

module EacCli
  class DocoptRunner
    include ::EacRubyUtils::Contextualizable

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
