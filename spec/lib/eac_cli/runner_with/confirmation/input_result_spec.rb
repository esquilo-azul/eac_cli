# frozen_string_literal: true

require 'eac_cli/runner_with/confirmation/input_result'
require 'eac_cli/speaker'
require 'eac_ruby_utils'

RSpec.describe EacCli::RunnerWith::Confirmation::InputResult do
  let(:speaker) { EacCli::Speaker.new }

  around do |example|
    EacRubyUtils::Speaker.context.on(speaker) { example.run }
  end

  before do
    allow(speaker).to receive(:warn) { |message| raise(message.to_s) }
  end

  [
    ['n', false, false],
    ['N', false, true],
    ['y', true, false],
    ['Y', true, true]
  ].each do |test_values|
    user_input, confirm, for_all = test_values # rubocop:disable RSpec/LeakyLocalVariable
    context "when user input is \"#{user_input}\"" do
      let(:instance) { described_class.by_message('A message') }

      before do
        allow(speaker).to receive(:request_string).and_return(user_input)
      end

      it { expect(instance.confirm?).to eq(confirm) }
      it { expect(instance.for_all?).to eq(for_all) }
    end
  end
end
