# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'shellwords'

module EacCli
  class DocoptRunner
    SUBCOMMAND_ARG = '<subcommand>'
    SUBCOMMAND_ARGS_ARG = '<subcommand-args>'
    SUBCOMMANDS_MACRO = '__SUBCOMMANDS__'

    def subcommands?
      source_doc.include?(SUBCOMMANDS_MACRO)
    end

    def check_subcommands
      return unless subcommands?

      singleton_class.include(SubcommandsSupport)
      check_subcommands_arg
      return if singleton_class.method_defined?(:run)

      singleton_class.send(:alias_method, :run, :run_with_subcommand)
    end

    module SubcommandsSupport
      EXTRA_AVAILABLE_SUBCOMMANDS_METHOD_NAME = :extra_available_subcommands

      def check_subcommands_arg
        if subcommand_arg_as_list?
          singleton_class.include(SubcommandsSupport::SubcommandArgAsList)
        else
          singleton_class.include(SubcommandsSupport::SubcommandArgAsArg)
        end
      end

      def run_with_subcommand
        if subcommand_name
          check_valid_subcommand
          subcommand_run
        else
          run_without_subcommand
        end
      end

      def subcommand
        @subcommand ||= subcommand_class_name(subcommand_name).constantize.create(
          argv: subcommand_args,
          program_name: subcommand_program,
          parent: self
        )
      end

      def subcommand_run
        if !subcommand.is_a?(::EacCli::DocoptRunner) &&
           subcommand.respond_to?(:run_run)
          subcommand.run_run
        else
          subcommand.run
        end
      end

      def target_doc
        super.gsub(SUBCOMMANDS_MACRO,
                   "#{target_doc_subcommand_arg} [#{SUBCOMMAND_ARGS_ARG}...]") +
          "\n" + subcommands_target_doc
      end

      def docopt_options
        super.merge(options_first: true)
      end

      def subcommand_class_name(subcommand)
        "#{self.class.name}::#{subcommand.underscore.camelize}"
      end

      def subcommand_arg_as_list?
        setting_value(:subcommand_arg_as_list, false) || false
      end

      def subcommand_args
        options.fetch(SUBCOMMAND_ARGS_ARG)
      end

      def subcommand_program
        subcommand_name
      end

      def available_subcommands
        r = ::Set.new(setting_value(:subcommands, false) || auto_available_subcommands)
        if respond_to?(EXTRA_AVAILABLE_SUBCOMMANDS_METHOD_NAME, true)
          r += send(EXTRA_AVAILABLE_SUBCOMMANDS_METHOD_NAME)
        end
        r.sort
      end

      def auto_available_subcommands
        self.class.constants
            .map { |name| self.class.const_get(name) }
            .select { |c| c.instance_of? Class }
            .select { |c| c < ::EacCli::DocoptRunner }
            .map { |c| c.name.demodulize.underscore.dasherize }
      end

      def run_without_subcommand
        "Method #{__method__} should be overrided in #{self.class.name}"
      end

      protected

      def check_valid_subcommand
        return if available_subcommands.include?(subcommand_name)

        raise ::Docopt::Exit, "\"#{subcommand_name}\" is not a valid subcommand" \
          " (Valid: #{available_subcommands.join(', ')})"
      end

      module SubcommandArgAsArg
        def target_doc_subcommand_arg
          SUBCOMMAND_ARG
        end

        def subcommand_name
          options.fetch(SUBCOMMAND_ARG)
        end

        def subcommands_target_doc
          available_subcommands.inject("Subcommands:\n") do |a, e|
            a + "  #{e}\n"
          end
        end
      end

      module SubcommandArgAsList
        def target_doc_subcommand_arg
          '(' + available_subcommands.join('|') + ')'
        end

        def subcommand_name
          available_subcommands.each do |subcommand|
            return subcommand if options.fetch(subcommand)
          end
          nil
        end

        def subcommands_target_doc
          "\n"
        end
      end
    end
  end
end
