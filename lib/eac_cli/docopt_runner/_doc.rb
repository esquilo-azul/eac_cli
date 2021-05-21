# frozen_string_literal: true

module EacCli
  class DocoptRunner
    PROGRAM_MACRO = '__PROGRAM__'

    def source_doc
      setting_value(:doc)
    end

    def target_doc
      source_doc.gsub(PROGRAM_MACRO, target_program_name).strip + "\n"
    end

    def source_program_name
      setting_value(:program_name, false)
    end

    def target_program_name
      [source_program_name, ENV['PROGRAM_NAME'], $PROGRAM_NAME].find(&:present?)
    end
  end
end
