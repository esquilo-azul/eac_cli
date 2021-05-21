# frozen_string_literal: true

require 'eac_cli/patches/module/speaker'

RSpec.describe ::Module do
  class StubClass # rubocop:disable RSpec/LeakyConstantDeclaration
    enable_speaker
  end

  describe '#enable_speaker' do
    it { expect(StubClass.included_modules).to include(::EacCli::Speaker) }
  end
end
