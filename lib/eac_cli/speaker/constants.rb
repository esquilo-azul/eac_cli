# frozen_string_literal: true

module EacCli
  class Speaker
    module Constants
      STDERR = ::EacRubyUtils::ByReference.new { $stderr }
      STDIN = ::EacRubyUtils::ByReference.new { $stdin }
      STDOUT = ::EacRubyUtils::ByReference.new { $stdout }
    end
  end
end
