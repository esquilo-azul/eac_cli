# frozen_string_literal: true

RSpec.describe EacCli::RunnerWith::OutputItem::AsciidocFormatter do
  include_examples 'source_target_fixtures', __FILE__

  # @return [String]
  def source_data(source_file)
    described_class.new(Psych.load_file(source_file)).to_output
  end

  # @param data [String]
  # @return [String]
  def target_content(data)
    data
  end

  # @return [String]
  def target_data(target_file)
    target_file.to_pathname.read
  end

  # @return [String]
  def target_file_extname
    '.adoc'
  end
end
