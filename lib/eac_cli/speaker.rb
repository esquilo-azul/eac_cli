# frozen_string_literal: true

require 'colorize'
require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/speaker/receiver'

module EacCli
  class Speaker
    require_sub __FILE__, include_modules: true
    include ::EacRubyUtils::Speaker::Receiver

    common_constructor :options, default: [{}] do
      self.options = self.class.lists.option.hash_keys_validate!(options)
    end

    def puts(string = '')
      string.to_s.each_line do |line|
        err_out.puts(err_line_prefix.to_s + line)
      end
    end

    def out(string = '')
      out_out.write(string.to_s)
    end

    def error(string)
      puts "ERROR: #{string}".white.on_red
    end

    def title(string)
      string = string.to_s
      puts(('-' * (8 + string.length)).green)
      puts("--- #{string} ---".green)
      puts(('-' * (8 + string.length)).green)
      puts
    end

    def info(string)
      puts string.to_s.white
    end

    def infom(string)
      puts string.to_s.light_yellow
    end

    def warn(string)
      puts string.to_s.yellow
    end

    # Options:
    #   +bool+ ([Boolean], default: +false+): requires a answer "yes" or "no".
    #   +list+ ([Hash] or [Array], default: +nil+): requires a answer from a list.
    #   +noecho+ ([Boolean], default: +false+): does not output answer.
    def input(question, options = {})
      bool, list, noecho, ignore_case =
        options.to_options_consumer.consume_all(:bool, :list, :noecho, :ignore_case)
      if list
        request_from_list(question, list, noecho, ignore_case)
      elsif bool
        request_from_bool(question, noecho)
      else
        request_string(question, noecho)
      end
    end

    def infov(*args)
      r = []
      args.each_with_index do |v, i|
        if i.even?
          r << "#{v}: ".cyan
        else
          r.last << v.to_s
        end
      end
      puts r.join(', ')
    end

    def success(string)
      puts string.to_s.green
    end

    private

    def list_value(list, input)
      values = list_values(list)
      return input, true unless values

      [input, false] unless values.include?(input)
    end

    def list_values(list)
      if list.is_a?(::Hash)
        list.keys.map(&:to_s)
      elsif list.is_a?(::Array)
        list.map(&:to_s)
      end
    end

    def request_from_bool(question, noecho)
      request_from_list(question, { yes: true, y: true, no: false, n: false }, noecho, true)
    end

    def request_string(question, noecho)
      err_out.write "#{question}: ".yellow
      noecho ? request_string_noecho : request_string_echo
    end

    def request_string_noecho
      r = in_in.noecho(&:gets).chomp.strip
      err_out.write("\n")
      r
    end

    def request_string_echo
      in_in.gets.chomp.strip
    end
  end
end
