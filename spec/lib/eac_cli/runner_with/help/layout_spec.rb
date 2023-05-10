# frozen_string_literal: true

require 'eac_cli/runner_with/help/layout'

::RSpec.describe ::EacCli::RunnerWith::Help::Layout do
  describe '#list_section' do
    {
      ['Options', ['Option A', 'Option B']] => <<~TEXT
        Options:
          Option A
          Option B
      TEXT
    }.each do |source, expected|
      context "when source is #{source}" do
        it do
          expect(described_class.list_section(*source)).to eq(expected)
        end
      end
    end
  end
end
