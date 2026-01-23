# frozen_string_literal: true

module EacCli
  class Config < ::SimpleDelegator
    def entry(path, options = {})
      ::EacCli::Config::Entry.new(self, path, options)
    end

    def sub
      __getobj__
    end
  end
end
