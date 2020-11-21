# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Parser
    require_sub __FILE__
    enable_simple_cache
    common_constructor :definition, :argv

    private

    def parsed_uncached
      raise 'Definition has no alternatives' if alternatives.empty?

      alternatives.each do |alt_parser|
        return alt_parser.parsed unless alt_parser.error?
      end

      raise first_error
    end

    def alternatives_uncached
      definition.alternatives
                .map { |alternative| ::EacCli::Parser::Alternative.new(alternative, argv) }
    end

    def first_error_uncached
      alternatives.lazy.select(&:error?).map(&:error).first
    end
  end
end
