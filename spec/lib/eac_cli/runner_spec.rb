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
      end

      def run; end
    end
  end

  context 'when all args are supplied' do
    let(:instance) { runner_class.create(%w[--opt1 aaa --opt2 bbb ccc ddd]) }

    it { expect(instance.parsed.opt1).to eq('aaa') }
    it { expect(instance.parsed.opt2?).to eq(true) }
    it { expect(instance.parsed.pos1).to eq('bbb') }
    it { expect(instance.parsed.pos2).to eq(%w[ccc ddd]) }
  end

  context 'when only required args are supplied' do
    let(:instance) { runner_class.create(%w[bbb]) }

    it { expect(instance.parsed.opt1).to be_nil }
    it { expect(instance.parsed.opt2?).to eq(false) }
    it { expect(instance.parsed.pos1).to eq('bbb') }
    it { expect(instance.parsed.pos2).to eq([]) }
  end

  context 'when required args are not supplied' do
    let(:instance) { runner_class.create(%w[]) }

    it do
      expect { instance.parsed }.to raise_error(::EacCli::Parser::Error)
    end
  end
end
