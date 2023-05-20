# frozen_string_literal: true

require 'eac_cli/runner'

::RSpec.describe ::EacCli::Runner do
  let(:parent_runner_class) do
    example = self
    ::Class.new do
      include example.described_class

      def self.name
        'ParentRunnerClass'
      end

      for_context :method_for_context

      def run; end

      def method_for_context; end

      def method_not_for_context; end
    end
  end

  let(:child_runner_class_1) do
    example = self
    ::Class.new do
      include example.described_class

      def self.name
        'ChildRunnerClass1'
      end

      def run
        method_for_context
        runner_context.call(:method_for_context)
        runner_context.call(:method_not_for_context)
      end
    end
  end

  let(:child_runner_class_2) do
    example = self
    ::Class.new do
      include example.described_class

      def self.name
        'ChildRunnerClass2'
      end

      def run
        method_not_for_context
      end
    end
  end

  let(:parent_runner) { parent_runner_class.create }
  let(:context_args) { [{ argv: [], parent: parent_runner }] }
  let(:child_runner) { child_runner_class.create(*context_args) }

  it { expect(parent_runner.for_context?(:method_for_context)).to eq(true) }
  it { expect(parent_runner.for_context?(:method_not_for_context)).to eq(false) }

  context 'when method is for context' do
    let(:child_runner_class) { child_runner_class_1 }

    it do
      expect { child_runner.run }.not_to raise_error
    end
  end

  context 'when method is not for context' do
    let(:child_runner_class) { child_runner_class_2 }

    it do
      expect { child_runner.run }.to raise_error(::NameError)
    end
  end
end
