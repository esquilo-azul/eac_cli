# frozen_string_literal: true

require 'eac_ruby_utils/console/docopt_runner'
require 'eac_cli/runner'

RSpec.describe ::EacCli::Runner do
  let(:runner_class) do
    the_module = described_class
    ::Class.new do
      include the_module

      runner_definition do
        arg_opt '-o', '--opt1', 'A arg option.'
        bool_opt '-o', '--opt2', 'A boolean option'
        pos_arg :pos1
        pos_arg :pos2, repeat: true, optional: true
        alt do
          bool_opt '-a', '--opt3', 'A boolean option in a alternative.', required: true
        end
      end

      def run; end
    end
  end

  let(:instance) { runner_class.create(argv) }
  let(:parsed_actual) { instance.parsed.to_h.symbolize_keys }

  context 'when all args are supplied' do
    let(:argv) { %w[--opt1 aaa --opt2 bbb ccc ddd] }
    let(:parsed_expected) { { opt1: 'aaa', opt2: true, pos1: 'bbb', pos2: %w[ccc ddd] } }

    it { expect(parsed_actual).to eq(parsed_expected) }
    it { expect(instance.parsed.opt1).to eq('aaa') }
    it { expect(instance.parsed.opt2?).to eq(true) }
    it { expect(instance.parsed.pos1).to eq('bbb') }
    it { expect(instance.parsed.pos2).to eq(%w[ccc ddd]) }
  end

  context 'when only required args are supplied' do
    let(:argv) { %w[bbb] }
    let(:parsed_expected) { { opt1: nil, opt2: false, pos1: 'bbb', pos2: [] } }

    it { expect(parsed_actual).to eq(parsed_expected) }
    it { expect(instance.parsed.opt1).to be_nil }
    it { expect(instance.parsed.opt2?).to eq(false) }
    it { expect(instance.parsed.pos1).to eq('bbb') }
    it { expect(instance.parsed.pos2).to eq([]) }
  end

  context 'when required args are not supplied' do
    let(:argv) { %w[] }

    it do
      expect { instance.parsed }.to raise_error(::EacCli::Parser::Error)
    end
  end

  context 'when alternative args are supplied' do
    let(:argv) { %w[--opt3] }
    let(:parsed_expected) { { opt3: true } }

    it { expect(parsed_actual).to eq(parsed_expected) }
    it { expect(instance.parsed.opt3?).to eq(true) }
  end

  context 'when extra args are not supplied' do
    let(:runner_class) do
      the_module = described_class
      ::Class.new do
        include the_module

        runner_definition do
          pos_arg :pos1
        end

        def run; end
      end
    end

    let(:argv) { %w[aaa bbb] }

    it do
      expect { instance.parsed }.to raise_error(::EacCli::Parser::Error)
    end
  end
end
