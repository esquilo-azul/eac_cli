# frozen_string_literal: true

module EacCli
  class Definition
    class BaseOption
      class InitializeArgsParser
        PROPERTIES = %i[short long description options].freeze
        attr_reader(*PROPERTIES)

        def initialize(args)
          self.options = args.extract_options!.freeze
          args.each { |arg| absorb_arg(arg) }
        end

        private

        attr_writer(*PROPERTIES)

        def absorb_arg(arg)
          arg_ext = ArgumentParser.new(arg)
          send("#{arg_ext.type}=", arg_ext.value)
        end

        class ArgumentParser
          TYPES = %i[short long description].freeze
          common_constructor :value

          def type
            TYPES.find { |type| send("#{type}?") } || raise("Unknown type for \"#{value}\"")
          end

          def short?
            value.start_with?('-') && !long?
          end

          def long?
            value.start_with?('--')
          end

          def description?
            !short? || !long?
          end
        end
      end
    end
  end
end
