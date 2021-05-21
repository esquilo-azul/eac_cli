# frozen_string_literal: true

require 'colorize'
require 'io/console'
require 'eac_ruby_utils/patches/hash/options_consumer'
require 'eac_ruby_utils/require_sub'
::EacRubyUtils.require_sub __FILE__

module EacCli
  # https://github.com/fazibear/colorize
  module Speaker
    def on_speaker_node(&block)
      ::EacCli::Speaker.on_node(&block)
    end

    def puts(string = '')
      string.to_s.each_line do |line|
        current_node.stderr.puts(current_node.stderr_line_prefix.to_s + line)
      end
    end

    def out(string = '')
      current_node.stdout.write(string.to_s)
    end

    def fatal_error(string)
      puts "ERROR: #{string}".white.on_red
      Kernel.exit 1
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
    def request_input(question, options = {})
      bool, list, noecho = options.to_options_consumer.consume_all(:bool, :list, :noecho)
      if list
        request_from_list(question, list, noecho)
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
      return input, false unless values.include?(input)
    end

    def list_values(list)
      if list.is_a?(::Hash)
        list.keys.map(&:to_s)
      elsif list.is_a?(::Array)
        list.map(&:to_s)
      end
    end

    def request_from_bool(question, noecho)
      request_from_list(question, { yes: true, y: true, no: false, n: false }, noecho)
    end

    def request_from_list(question, list, noecho)
      list = ::EacCli::Speaker::List.build(list)
      loop do
        input = request_string("#{question} [#{list.valid_labels.join('/')}]", noecho)
        return list.build_value(input) if list.valid_value?(input)

        warn "Invalid input: \"#{input}\" (Valid: #{list.valid_labels.join(', ')})"
      end
    end

    def request_string(question, noecho)
      current_node.stderr.write "#{question}: ".to_s.yellow
      noecho ? request_string_noecho : request_string_echo
    end

    def request_string_noecho
      r = current_node.stdin.noecho(&:gets).chomp.strip
      current_node.stderr.write("\n")
      r
    end

    def request_string_echo
      current_node.stdin.gets.chomp.strip
    end

    def current_node
      ::EacCli::Speaker.current_node
    end
  end
end
