# frozen_string_literal: true

require 'eac_ruby_utils/by_reference'

module EacCli
  # https://github.com/fazibear/colorize
  module Speaker
    STDERR = ::EacRubyUtils::ByReference.new { $stderr }
    STDIN = ::EacRubyUtils::ByReference.new { $stdin }
    STDOUT = ::EacRubyUtils::ByReference.new { $stdout }
  end
end
