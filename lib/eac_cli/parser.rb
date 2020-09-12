# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacCli
  class Parser
    require_sub __FILE__
    common_constructor :definition

    def parse(argv)
      ::EacCli::Parser::ParseResult.new(definition, argv).result
    end
  end
end
