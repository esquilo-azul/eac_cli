# frozen_string_literal: true

RSpec.describe EacCli::RunnerWith::Output do
  let(:runner) do
    the_module = described_class
    Class.new do
      include the_module

      attr_accessor :temp_dir

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

      def default_file_to_output
        temp_dir.join('default_file')
      end
    end
  end

  let(:stub_text) { 'STUB_TEXT' }
  let(:instance) do
    r = runner.create(argv: runner_argv)
    r.temp_dir = temp_dir
    r
  end
  let(:temp_dir) { EacRubyUtils::Fs::Temp.directory }

  after { temp_dir.remove }

  context 'without --output option' do
    let(:runner_argv) { [stub_text] }

    it do
      expect { instance.run }.to output(stub_text).to_stdout_from_any_process
    end
  end

  context 'without --output option as to stdout' do
    let(:runner_argv) { ['--output', EacCli::RunnerWith::Output::STDOUT_OPTION, stub_text] }

    it do
      expect { instance.run }.to output(stub_text).to_stdout_from_any_process
    end
  end

  context 'without --output option as to default file' do
    let(:output_file) { temp_dir.join('default_file') }
    let(:runner_argv) do
      ['--output', EacCli::RunnerWith::Output::DEFAULT_FILE_OPTION,
       stub_text]
    end

    before { instance.run }

    it { expect(output_file).to exist }
    it { expect(output_file.read).to eq(stub_text) }
  end

  context 'with --output option' do
    let(:output_file) { temp_dir.join('a output file') }
    let(:runner_argv) { ['--output', output_file.to_path, stub_text] }

    before { instance.run }

    it { expect(output_file).to exist }
    it { expect(output_file.read).to eq(stub_text) }
  end
end
