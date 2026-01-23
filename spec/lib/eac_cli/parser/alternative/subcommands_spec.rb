# frozen_string_literal: true

RSpec.describe EacCli::Parser::Alternative, '#subcommands' do
  let(:instance) { described_class.new(alternative, argv) }
  let(:actual_parsed) { instance.parsed.to_h.symbolize_keys }
  let(:alternative) do
    r = EacCli::Definition::Alternative.new
    r.bool_opt '-b', '--opt1', 'A boolean option'
    r.arg_opt '-a', '--opt2', 'A argument option'
    r.subcommands
    r
  end

  context 'with all values' do
    let(:argv) { %w[--opt1 --opt2 OPT2 CMD CMD_ARG_1 --CMD_ARG_2] }
    let(:parsed_expected) do
      {
        opt1: true, opt2: 'OPT2',
        EacCli::Definition::Alternative::SUBCOMMAND_NAME_ARG => 'CMD',
        EacCli::Definition::Alternative::SUBCOMMAND_ARGS_ARG => %w[CMD_ARG_1 --CMD_ARG_2]
      }
    end

    it { expect(instance.error).to be_blank }
    it { expect(actual_parsed).to eq(parsed_expected) }
  end

  context 'with only required values' do
    let(:argv) { %w[CMD] }
    let(:parsed_expected) do
      {
        opt1: false, opt2: nil,
        EacCli::Definition::Alternative::SUBCOMMAND_NAME_ARG => 'CMD',
        EacCli::Definition::Alternative::SUBCOMMAND_ARGS_ARG => []
      }
    end

    it { expect(instance.error).to be_blank }
    it { expect(actual_parsed).to eq(parsed_expected) }
  end

  context 'without required values' do
    let(:argv) { %w[--opt1] }
    let(:parsed_expected) do
      {
        opt1: true, opt2: nil,
        EacCli::Definition::Alternative::SUBCOMMAND_NAME_ARG => nil,
        EacCli::Definition::Alternative::SUBCOMMAND_ARGS_ARG => []
      }
    end

    it { expect(instance.error).to be_present }
    it { expect(actual_parsed).to eq(parsed_expected) }
  end
end
