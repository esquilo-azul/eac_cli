# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Parser
    require_sub __FILE__
    common_constructor :definition, :argv

    def parse
      result_or_error = parse_definition(definition)
      return result_or_error unless result_or_error.is_a?(::Exception)

      definition.alternatives.each do |alternative|
        alt_result_or_error = parse_definition(alternative)
        return alt_result_or_error unless alt_result_or_error.is_a?(::Exception)
      end

      raise result_or_error
    end

    private

    def parse_definition(definition)
      ::EacCli::Parser::Collector.to_data(definition) do |collector|
        ::EacCli::Parser::PositionalCollection.new(
          definition,
          ::EacCli::Parser::OptionsCollection.new(definition, argv, collector).arguments,
          collector
        )
      end
    rescue ::EacCli::Parser::Error => e
      e
    end
  end
end
