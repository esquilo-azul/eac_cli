# frozen_string_literal: true

module EacCli
  class Parser
    require_sub __FILE__
    enable_simple_cache
    common_constructor :definition, :argv

    private

    def parsed_uncached
      raise 'Definition has no alternatives' if alternatives.empty?
      raise first_error unless alternatives.any?(&:success?)

      alternatives_parsed(true).merge(alternatives_parsed(false))
    end

    def alternatives_parsed(error)
      alternatives.select { |a| error == a.error? }.map(&:parsed).reverse
        .inject(::EacRubyUtils::Struct.new) { |a, e| a.merge(e) }
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
