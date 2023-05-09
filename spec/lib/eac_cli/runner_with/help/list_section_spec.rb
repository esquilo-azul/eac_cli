# frozen_string_literal: true

require 'eac_cli/runner_with/help/list_section'

::RSpec.describe ::EacCli::RunnerWith::Help::ListSection do
  {
    ['Options', ['Option A', 'Option B']] => <<~TEXT
      Options:
        Option A
        Option B
    TEXT
  }.each do |source, expected|
    context "when source is #{source}" do
      let(:instance) { described_class.new(*source) }

      it do
        expect(instance.to_s).to eq(expected)
      end
    end
  end
end
