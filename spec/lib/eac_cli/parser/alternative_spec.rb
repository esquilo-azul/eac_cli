# frozen_string_literal: true

RSpec.describe ::EacCli::Parser::Alternative do
  let(:instance) { described_class.new(alternative, argv) }
  let(:actual_parsed) { instance.parsed.to_h.symbolize_keys }

  context 'without subcommands' do
    let(:alternative) do
      r = ::EacCli::Definition::Alternative.new
      r.bool_opt '-b', '--opt1', 'A boolean option'
      r.arg_opt '-a', '--opt2', 'A argument option'
      r.bool_opt '-c', '--opt3', 'A required boolean option', required: true
      r.pos_arg :pos1
      r.pos_arg :pos2, optional: true, repeat: true
      r
    end

    context 'with all values' do
      let(:argv) { %w[--opt1 --opt2 OPT2 --opt3 POS1 POS2_1 POS2_2] }
      let(:parsed_expected) do
        {
          opt1: true, opt2: 'OPT2', opt3: true, pos1: 'POS1', pos2: %w[POS2_1 POS2_2]
        }
      end

      it { expect(instance.error).to be_blank }
      it { expect(actual_parsed).to eq(parsed_expected) }
    end

    context 'with only required values' do
      let(:argv) { %w[--opt3 POS1] }
      let(:parsed_expected) { { opt1: false, opt2: nil, opt3: true, pos1: 'POS1', pos2: [] } }

      it { expect(instance.error).to be_blank }
      it { expect(actual_parsed).to eq(parsed_expected) }
    end

    context 'with double dash' do
      let(:argv) { %w[--opt3 POS1 -- --opt1 --] }
      let(:parsed_expected) do
        { opt1: false, opt2: nil, opt3: true, pos1: 'POS1', pos2: %w[--opt1 --] }
      end

      it { expect(instance.error).to be_blank }
      it { expect(actual_parsed).to eq(parsed_expected) }
    end

    context 'without required positional' do
      let(:argv) { %w[--opt1 --opt3] }
      let(:parsed_expected) { { opt1: true, opt2: nil, opt3: true, pos1: nil, pos2: [] } }

      it { expect(instance.error).to be_present }
      it { expect(actual_parsed).to eq(parsed_expected) }
    end

    context 'without required option' do
      let(:argv) { %w[--opt1 POS1] }
      let(:parsed_expected) { { opt1: true, opt2: nil, opt3: false, pos1: 'POS1', pos2: [] } }

      it { expect(instance.error).to be_present }
      it { expect(actual_parsed).to eq(parsed_expected) }
    end

    context 'without any required option or positional' do
      let(:argv) { %w[] }
      let(:parsed_expected) { { opt1: false, opt2: nil, opt3: false, pos1: nil, pos2: [] } }

      it { expect(instance.error).to be_present }
      it { expect(actual_parsed).to eq(parsed_expected) }
    end

    context 'with excedent positional' do
      let(:alternative) do
        r = ::EacCli::Definition::Alternative.new
        r.pos_arg :pos1
        r
      end

      let(:argv) { %w[POS1 POS2] }
      let(:parsed_expected) { { pos1: 'POS1' } }

      it { expect(instance.error).to be_present }
      it { expect(actual_parsed).to eq(parsed_expected) }
    end
  end

  context 'with subcommands' do
    let(:alternative) do
      r = ::EacCli::Definition::Alternative.new
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
          ::EacCli::Definition::Alternative::SUBCOMMAND_NAME_ARG => 'CMD',
          ::EacCli::Definition::Alternative::SUBCOMMAND_ARGS_ARG => %w[CMD_ARG_1 --CMD_ARG_2]
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
          ::EacCli::Definition::Alternative::SUBCOMMAND_NAME_ARG => 'CMD',
          ::EacCli::Definition::Alternative::SUBCOMMAND_ARGS_ARG => []
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
          ::EacCli::Definition::Alternative::SUBCOMMAND_NAME_ARG => nil,
          ::EacCli::Definition::Alternative::SUBCOMMAND_ARGS_ARG => []
        }
      end

      it { expect(instance.error).to be_present }
      it { expect(actual_parsed).to eq(parsed_expected) }
    end
  end
end
