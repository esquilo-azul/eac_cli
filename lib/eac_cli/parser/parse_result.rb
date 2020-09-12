# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Parser
    class ParseResult
      common_constructor :definition, :argv

      def result
        ::EacCli::Parser::Collector.to_data(definition) do |collector|
          ::EacCli::Parser::PositionalCollection.new(
            definition,
            ::EacCli::Parser::OptionsCollection.new(definition, argv, collector).arguments,
            collector
          )
        end
      end
    end
  end
end
