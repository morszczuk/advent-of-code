module Aoc2020
  module Day19
    class Grammatic
      attr_reader :rules

      def initialize(rules, terminals)
        @terminals = terminals
        @rules = rules.merge(@terminals)

        fix_chomsky if @rules.any? { |_key, value| value.any? { |r| r.size > 2 }}

        @product_to_non_terminal = prepare_product_to_non_terminal(@rules)
      end

      def non_terminal_rule(value)
        [@terminals.select { |_key, val| val.include?([value]) }.first[0]]
      end

      def find_productions(result)
        @product_to_non_terminal[result.flatten]
      end

      def fix_chomsky
        bads = @rules.select { |_key, value| value.any? { |r| r.size > 2 }}
        bads.each do |bad_key, bad_values|
          max_key = @rules.keys.map(&:to_i).max
          new_key = (max_key + 1).to_s

          new_value = bad_values.first.first(2)

          @rules[new_key] = [new_value]
          @rules[bad_key] = [[new_key, bad_values.first.last]]
        end
      end

      def prepare_product_to_non_terminal(rules)
        product_to_non_terminal = Hash.new { [] }

        rules.each do |terminal, products|
          products.each do |product|
            product_to_non_terminal[product] += [[terminal]]
          end
        end

        product_to_non_terminal
      end
    end

    class AlgorithmCYK
      def initialize(grammatic, message)
        @grammatic = grammatic
        @message = message
        @table = Hash.new { [] }
        @algorithm_table = Array.new(@message.size) { Array.new(@message.size) { -1 } }

        @ticks = 0
      end

      def find_links(x, y)
        @table[[x, y]]
      end

      def call
        start_time = Time.now

        finding_links = 0
        finding_productions = 0
        finding_productions_1 = 0
        finding_productions_2 = 0

        @message.chars.each_with_index do |non_terminal, index|
          # pp "About to set #{[0, index, [@grammatic.non_terminal_rule(non_terminal)]]}"
          @table[[0, index]] += [@grammatic.non_terminal_rule(non_terminal)]
          # @algorithm_table[0][index] = @grammatic.non_terminal_rule(non_terminal)
        end

        # byebug

        n = @message.size

        (2..(n)).each do |l|
          (1..(n-l + 1)).each do |s|
            (1..(l - 1)).each do |p|

              @ticks += 1

              # puts "\n\n\nNext iteration"
              # pp "First elem: #{[p -1, s -1]}"
              # pp "Second elem: #{[l-p -1, s + p -1]}"
              # pp "Element to set: #{[l -1, s-1]}"

              find_links_time = Time.now

              production_x = find_links(*[p -1, s -1])
              production_y = find_links(*[l-p -1, s + p - 1])

              finding_links += (Time.now - find_links_time)

              # if l - 1 == 22 || l - 1 == 23

              #   pp 'Productions found'
              #   pp production_x
              #   pp production_y

              # end
              # possible_keys = production_x.product(production_y)

              # pp 'Possible keys'
              # pp possible_keys

              # iteration_time = Time.now
              find_prods_time_1 = Time.now

              found_productions = production_x
              if production_x.present? && production_y.present?
                found_productions = production_x.product(production_y)
              else
                # pp production_x

                found_productions = production_y

                # found_productions = production_y if production_y.present?
              end

              finding_productions_1 += (Time.now - find_prods_time_1)

              find_prods_time_2 = Time.now

              # if l - 1 == 22 || l - 1 == 23

              #   pp "Found productions before"
              #   pp found_productions
              # end



              found_productions = found_productions.map { |key| @grammatic.find_productions(key) }.flatten(1)


              finding_productions_2 += (Time.now - find_prods_time_2)

              # if l - 1 == 22 || l - 1 == 23

              #   pp "Found productions after"
              #   pp found_productions
              # end

              # byebug if l - 1 == 22
              # byebug if l - 1 == 23

              found_productions.each do |prod|
                @table[[l - 1, s - 1]] += [prod]
              end

              # pp "Iteration time: #{Time.now - iteration_time}"

              # byebug


              # pp "Found productions = #{found_productions}"





              # pp 'Current table:'
              # pp @table
              # byebug

              # production_to_find = @table.select { |key| key[0] == }



              # for each production Ra    → Rb Rc
                # if P[p,s,b] and P[l-p,s+p,c] then set P[l,s,a] = true
            end
          end
        end

        # pp 'All done!'
        # pp @table

        # pp 'This result determines result:'
        # pp [@message.size - 1, 0, '0']
        # pp @table[[@message.size - 1, 0, '0']]
        # byebug

        # pp "Total time: #{Time.now - start_time}"
        # pp "Finding productions 1: #{finding_productions_1}"
        # pp "Finding productions 2: #{finding_productions_2}"
        # pp "Finding links: #{finding_links}"
        # pp "Ticks done: #{@ticks}"
        # pp @table

        # byebug

        @table[[@message.size - 1, 0]].include? ['0']

        # n = @message.size
        # js = (1..n -1)
        # js.each do |j|
        #   is = (0..(n - j + 1))
        #   is.each do |i|
        #     ks = (1..(j -1))
        #     ks.each do |k|
        #       pp
        #       pp "First elem: #{[k, i]}"
        #       pp "Second elem: #{[j - k, i + k]}"

        #       pp "Element to set: #{[j, i]}"

        #       pp [j, i, k]
        #       byebug
        #     end
        #   end
        # end

        # @algorithm_table
      end
    end

    class RegexBuilder
      attr_reader :rules

      def initialize(rules, terminals, multiple: false)
        @rules = rules
        @terminals = terminals.transform_values(&:flatten).transform_values(&:first)
        @multiple = multiple

        if @multiple
          @terminals['gdh'] = 'gdhaha'
          @terminals['gdj'] = 'jahaha'
          @rules['8'] = [['gdh']]
          @rules['11'] = [['gdj']]
        end
      end

      def call
        res = non_terminal_rule('0')
        regex = join_rules(res)

        if @multiple
          rule_31 = join_rules(non_terminal_rule('31'))
          rule_42 = join_rules(non_terminal_rule('42'))

          rule_8 = "(#{rule_42})+"
          rule_11 = "(?<rule>#{rule_42}(\\g<rule>*)#{rule_31})"

          regex.gsub!('gdhaha', rule_8)
          regex.gsub!('jahaha', rule_11)
        end

        /^#{regex}$/
      end

      def non_terminal_rule(rule)
        @rules[rule].map do |e|
          e.map do |ee|
            @terminals[ee] || non_terminal_rule(ee)
          end
        end
      end

      def join_rules(rules)
        return rules if rules.is_a?(String)

        rules_regex = rules.map do |rule|
          rule.is_a?(String) ? rule : rule.map(&method(:join_rules)).join('')
        end.join('|')

        "(#{rules_regex})"
      end
    end

    class Puzzle19 < ::Aoc::PuzzleBase
      def initialize
        @rules = {}
        @terminals = {}
        @messages = []
        super()
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        return if line.empty?

        if line.include? ':'
          key, raw_rule = line.split(': ')
          rule = raw_rule.split(' | ')

          if raw_rule.include?('"')
            @terminals[key] = rule.map { |e| e.tr('"', '') }.map { |ee| [ee]}
          else
            @rules[key] = rule.map { |e| e.split(' ').map { |ee| ee.tr(' ', '') } }
          end

        else
          @messages << line
        end
      end

      def unit_tests
        # data = ['11100110001000000110011001101011011100000110001001110011011100100111010001110101011001100111010101100010011000110110001101101100011101110110100101100110011000010110111101110111011011010110110101110000011011110111000101101001011100100110101101101000011001110110110000001010011101000111001001100100011101000110001000001111',
        # '00010000011010000111101001110110011101100110000101111001011100110110111001101111011010000110101001100101011100110111001101110011000111100110101101111001011100000001011101100010011101110000110001101010011001000111100101111010011101010110111000010100011100100110001001100010011101010110111101110101011110000110001101110011',
        # '01111001000111110110111001101000011100010110110101101100000011010110000101110000001011010110001101110100000101100110011101100011011101110110110101110001011101110110010101101001011001100111101001101010011010010110100101100100011100010111011101100100000001110111010101100100011110000110001101111010011010100111010101101001',
        # '01101001011001100111011101101100011001000110010001100110011100010110010001101010011110100111000001110101011100010001001001100110011110000110101100100100011011010110000101100011011001100110110101100010011101000110011001111000011110000111000101110111011011100111100000011001011101110110001000100001011011100111100001101100',
        # '01110100011001100110101001100010011001010110110001101111011001100110011101100011011001000100010110100010011011000111000001101110011011010111101001110110011100100111000101100100000111110111100101100111011011100110100000011110011100010110111000101101000110110110100101110110011001110110100101110110011000110110111101100010',
        # '01101101011000010000011001111001011100000110111000001011011011100110010100101101011010000001010101100101011010110111010001101101011001100111100101110011001011010110101101110110011000010110100001110101011010100110000101101110011100100110000101101110011000110110011101110101011011000111101001110101011010110110111101101011',
        # '01100011011010100111001001110000011110000111000101100111011110010111001101110010011101010010110101101011011100110001111001100111011110000110101101110110011110010001011101110100011000010110010101101100011001000111101001100001011011100110001000100011011100010110110101100001011010110001010001111001011001000111001101110001',
        # '00100101011000100110000101110011011000110111010101101001011000100110111001111000011010010110101001100100011101000110010101111010011101110111011001101001011100100110100101110110011001010010110101110100011011000110101001101100011001110000100001100010011001110010110101101000011101110110011101101011000111010110011101101101',
        # '01100100011011000111001001101111011110010110101001110001011001110010110101100010001011010110001101100000111000010010011001100011011011010110010001111000011110010110110101111010011101000111010101101100011100000110010001101101011100000110100101100010011011010110110101101101011010010110100101100101011110100001011001101000',
        # '00011001011010100111000001100010011101110110010101100100011110010111100101101011011000110111001101100011011011000110001001110001011101100110101001110100011100100111010001101100011100000110111101110111000111100111001101110011011011000111010000010011011101100110001101100010011110100111010001100011011011110110001101101110',
        # '00100011011100010010110101101001011000010111100101110101011001110110001001100011011010010111100101101001001011010110111101110001011010110110011101111000011100110110110101110011011011100110011101100011000010100111100101100110011010100001100101101101011011010111011100101101011010100001110101110101011101100110101001100001',
        # '01110110011100000111001100001011011010110110100001100111011110000111101001110010001011010001101101100111011001000111101001101111011100000111011101111010011011100110101001110110011011110110111001101100011100100111001000100001001011010010110101100010011010100110111101100011011001010111011100101101011101110111000001101111',
        # '01111010011010010110101001111001011100100111010101101110011001000111011101100001011100000110110000100100011101110111100101101010011001000010011101100111011001100111010101111001011010010110101100101101011101100111101001110011011000010110101101111001011100100110110000101101011001100110100100010001011001010111001100100000',
        # '01101011011001100111001101100110011100010110011101101110011110000110110001100100011001000111010101110000011010110111000101110011011101010001010001100100011000010010001101100100011100010110010101110001011110100110011001100010011000010111101000101101011101010001011101110000011010010010011001110100011101110010000001100110']

        # res = data.map do |channel|
        #   channel_size = channel.size / 8
        #   res = channel.chars.each_slice(8).to_a.map do |byte|
        #     next_id = byte.join('').reverse
        #     next_channel_id = next_id.to_i(2)
        #     pp next_id
        #     pp next_id.to_i(2)

        #     # byebug
        #     next_channel_id if next_channel_id <= channel_size
        #   end.compact
        # end
        # pp res
        # byebug
        # res

        # .flatten.join('')
      end
    end
  end
end
