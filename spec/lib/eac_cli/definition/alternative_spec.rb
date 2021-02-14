# frozen_string_literal: true

require 'eac_cli/definition/alternative'

RSpec.describe ::EacCli::Definition::Alternative do
  let(:instance) { described_class.new }

  it { expect { instance.arg_opt '-a', '--opt2', 'A argument option' }.not_to raise_error }
  it { expect { instance.bool_opt '-b', '--opt1', 'A boolean option' }.not_to raise_error }
  it { expect { instance.bool_opt '-b', '--no-description' }.not_to raise_error }
  it { expect { instance.bool_opt '--opt1', 'A option without short' }.not_to raise_error }
  it { expect { instance.bool_opt '-b', 'A option without long' }.not_to raise_error }
  it { expect { instance.bool_opt 'A option without selectors' }.to raise_error(::StandardError) }
  it { expect { instance.options_argument(true) }.not_to raise_error }
  it { expect { instance.pos_arg :pos1 }.not_to raise_error }
  it { expect { instance.pos_arg :pos2, optional: true, repeat: true }.not_to raise_error }
  it { expect { instance.subcommands }.not_to raise_error }
end
