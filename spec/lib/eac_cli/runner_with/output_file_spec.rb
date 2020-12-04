# frozen_string_literal: true

require 'eac_cli/runner_with/output_file'
require 'eac_ruby_utils/fs/temp'

RSpec.describe ::EacCli::RunnerWith::OutputFile do
  let(:runner) do
    the_module = described_class
    Class.new do
      include the_module

      runner_definition do
        desc 'A stub root runner.'
        pos_arg :input_text
      end

      def run
        run_output
      end

      def output_content
        parsed.input_text
      end
    end
  end

  let(:stub_text) { 'STUB_TEXT' }
  let(:instance) { runner.create(argv: runner_argv) }

  context 'without --output-file option' do
    let(:runner_argv) { [stub_text] }

    it do
      expect { instance.run }.to output(stub_text).to_stdout_from_any_process
    end
  end

  context 'with --output-file option' do
    let(:output_file) { ::EacRubyUtils::Fs::Temp.file }
    let(:runner_argv) { ['--output-file', output_file.to_path, stub_text] }

    before do
      instance.run
    end

    after do
      output_file.remove
    end

    it { expect(output_file).to exist }
    it { expect(output_file.read).to eq(stub_text) }
  end
end
