module Aoc2021
  module Day8
    class CodedEntry
      MAPPING = {
        0 => ['a', 'b', 'c', 'e', 'f', 'g'],
        1 => ['c', 'f'],
        2 => ['a', 'c', 'd', 'e', 'g'],
        3 => ['a', 'c', 'd', 'f', 'g'],
        4 => ['b', 'c', 'd', 'f'],
        5 => ['a', 'b', 'd', 'f', 'g'],
        6 => ['a', 'b', 'd', 'e', 'f', 'g'],
        7 => ['a', 'c', 'f'],
        8 => ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
        9 => ['a', 'b', 'c', 'd', 'f', 'g'],
      }
      RECOGNIZABLE = {
        2 => 1,
        3 => 7,
        4 => 4,
        7 => 8
      }
      attr_reader :signals, :output, :ordered_signals, :ordered_output

      def initialize(signals, output)
        @signals = signals
        @output = output
        @real_output = output
        @signals = @ordered_signals = signals.sort
        @output = @ordered_output = output.sort
      end

      def self.parse(line)
        raw_signals, raw_output = line.split(' | ')
        raw_signals = raw_signals.split(' ')
        raw_output = raw_output.split(' ')
        # pp raw_signals
        # pp raw_output
        new(raw_signals, raw_output)
      end

      def decoded_output_values
        @decoding = value

        res = decode_output_values.map(&:to_s).join('').to_i

        pp res

        res
      end

      def decode_output_values
        @real_output.map(&:chars)
        .map { |att| att.map { |char| @decoding[char] }.sort }
        .map { |decoded_value| MAPPING.find { |k, v| v.sort == decoded_value.sort }.first }
      end

      def recognizeble_numbers
        # pp 'Output'
        # pp output
        # pp 'Recognised'
        (res = @output.select { |s| RECOGNIZABLE.key? s.size })

        res

        # @output.map(&:size).select { |s| RECOGNIZABLE.include? s}.size
      end

      def all_recognizeble_numbers(input)
        input.select { |s| RECOGNIZABLE.key? s.size }
      end

      def value
        connection = fresh_connection

        # (signals + output).each do |elem|
        #   connection = identify_connection(elem, connection)
        #   # pp elem
        # end

        connection = empty_connection
        (signals + output).each do |elem|
          connection = add_connection(elem, connection)
        end

        # pp connection

        recognised = all_recognizeble_numbers(signals + output)
        # pp recognised
        recognised.each do |recognised_number|
          recognised_number_chars = recognised_number.chars
          elems_to_map = MAPPING[RECOGNIZABLE[recognised_number.size]]
          elems_to_map.each do |elem_to_map|
            connection[elem_to_map] &= recognised_number_chars
          end
          # byebug
        end

        # pp connection

        # byebug

        # recognizeble_numbers.each do |num|
        #   connection = identify_connection(num, connection)
        # end

        previous_connection = nil
        while previous_connection != connection.hash
          previous_connection = connection.hash
        # until all_recognised?(connection)
          # find_matched = connection.select { |_k, v| v.values
          # find_matched = connection.values.tally.select { |elem, occ| elem.size == occ }.map(&:first).reduce(&:+)
          # pp find_matched
          # pp connection

          # connection.transform_values! { |val| val -= find_matched unless val == find_matched }

          connection.values.tally.select { |elem, occ| elem.size == occ }.map(&:first).each do |solved|
            connection.transform_values! do |val|
              # pp val
              # pp solved
              # byebug if vall == solved
              val == solved ? val : val -= solved
            end
          end
          # pp connection

          # byebug
        end

        expertiment(connection)
      end

      def all_chars
        ('a'..'g').to_a
      end

      def all_recognised?(connection)
        connection.values.all? do |val|
          val.one?
          # || RECOGNIZABLE.key?(val.size)
        end
      end

      def fresh_connection
        Hash[all_chars.product([all_chars])]
      end

      def empty_connection
        Hash[all_chars.product([[]])]
      end

      def identify_connection(num, connection)
        # MAPPING.select { |key, values|  }
        real = MAPPING.values.select { |value| value.size == num.size }
        # pp "Num: #{num}, size: #{num.size}"
        # pp real
        real = real.reduce(&:+).uniq.sort
        # pp real
        # byebug

        # real = MAPPING[RECOGNIZABLE[num.size]]


        # return unless real.present?

        real.each do |char_to_map|
          connection[char_to_map] &= num.split('')
        end

        # num.chars.each do |char|
        #   connection[char] &= real
        # end
        connection
      end

      def add_connection(elem, connection)
        real = MAPPING.values.select { |value| value.size == elem.size }
        real = real.reduce(&:+).uniq.sort

        chars = elem.split('')

        # pp "Real: #{real}"
        # pp "Chars: #{chars}"
        real.each do |char_to_map|
          # pp "Char to map: #{char_to_map}"
          # pp "Connection: #{connection}"
          # pp "Connection of Char to map: #{connection[char_to_map]}"
          connection[char_to_map] |= chars
          # connection[char_to_map] = connection[char_to_map].uniq
        end

        connection
      end

      def expertiment(connection)
        # identified = connection.select { |_k, v| v.one? }.to_h
        decoding = {}
        identified = connection.select { |_k, v| v.one? }.transform_values!(&:first)

        identified.each { |k, v| decoding[v] = k }
        pp decoding


        recognised_with_number = identified_plus_number = all_recognizeble_numbers(signals + output).map do |num|
          [
            num.chars,
            RECOGNIZABLE[num.size]
          ]
        end.to_h

        group_decoding = recognised_with_number.map {|num, value| [num, MAPPING[value] ] }.to_h
        # byebug
        to_check = identified_plus_number.select { |k, v| (k & decoding.keys).present? }

        to_decode = identified_plus_number.select { |k, v| (k & decoding.keys).size == k.size - 1 }


        pp identified
        pp identified_plus_number
        pp to_check
        pp to_decode
        pp group_decoding

        confirmed_decoding = decoding
        potential_decoding = {}
        connection.each do |k, v|
          v.each do |value_to_decode|
            potential_decoding[value_to_decode] ||= []
            potential_decoding[value_to_decode] |= [k]
          end
        end

        pp confirmed_decoding
        pp potential_decoding

        bactracking_entry(potential_decoding)

        @result

        # tried_decodings = []

        # while true do
        #   new_decoding = {}
        #   all_chars.each do |char|
        #     possible_decodings = potential_decoding[char].sort
        #     used_chars = new_decoding.values
        #     new_decoding[char] = (possible_decodings - used_chars).first
        #   end
        #   pp new_decoding
        #   byebug
        # end

        # all_options_to_try

        # byebug



        # byebug
        # to_check.each do |number_to_decode, expected_value|
        #   # decode(number_to_decode, expected_value, identified)
        #   decoding, gruop_decoding = attempt_decode(number_to_decode, expected_value, connection, decoding, group_decoding)
        # end



        # (signals + output).each do |elem|
        #   decoding, gruop_decoding = attempt_full_decode(elem.chars, connection, decoding, group_decoding)
        # end

        # connection
      end

      def bactracking_entry(potential_decoding)
        @tried_options = []
        build_decoding_back(0, {}, potential_decoding)
      end

      def build_decoding_back(char_position, decoding, potential_decoding)
        return if @result.present?

        char = all_chars[char_position]

        # pp "Bactrack step"
        # pp char_position
        # pp char
        # pp decoding


        if decoding.keys.size == all_chars.size
          # pp "Tried options"
          # pp @tried_options
          # byebug
          @tried_options << decoding
          # byebug if decoding == { 'a' => 'c', 'b' => 'f', 'c' => 'g', 'd' => 'a', 'e' => 'b', 'f' => 'd', 'g' => 'e'}
          result =
          # byebug if result

          @result = decoding if check_decoding_correctness(decoding)
        else
          possible_options = potential_decoding[char] - decoding.values
          possible_options.each do |option|
            build_decoding_back(char_position + 1, decoding.merge( { char => option }), potential_decoding)
          end
        end
      end

      def prepare_all_options_to_try(potential_decoding)
        all_options = []
        leters = all_chars
        leters.each do |char|
          new_option = {}
          possible_decodings = potential_decoding[char]

        end
      end

      def check_decoding_correctness(decoding)
        all_values = signals + output

        decoded = all_values.map(&:chars).map { |att| att.map { |char| decoding[char] }.sort }

        # pp decoded

        # byebug if decoding == { 'a' => 'c', 'b' => 'f', 'c' => 'g', 'd' => 'a', 'e' => 'b', 'f' => 'd', 'g' => 'e'}

        decoded.all? { |decoded_value| MAPPING.has_value? decoded_value }
      end

      def decode(coded_number_chars, expected_value, existing_connection)
        expected_chars = MAPPING[expected_value]
        decoded = coded_number_chars.map { |coded_char| existing_connection[coded_char] || coded_char }

        # pp decoded
        # byebug

      end

      def attempt_decode(coded_number_chars, expected_value, existing_connection, decode, group_decoding)
        # p "ATTEMPT DECODE"
        # pp coded_number_chars
        # pp expected_value
        # pp existing_connection
        # pp decode
        # pp group_decoding
        expected_chars = MAPPING[expected_value]

        # pp expected_chars
        # pp "Decoding"
        decode_found = group_decoding.find { |k, v| (coded_number_chars - k).one? && coded_number_chars.size - 1 == k.size }
        if decode_found
          # pp decode_found
          # decode_found = decode_found.to_a.first

          new_decoded_symbol = coded_number_chars - decode_found.first
          decoded_value = expected_chars - decode_found.last
          res =  [new_decoded_symbol, decoded_value]
          # pp res
          # byebug
          res
        else
          fdas = 5
        end
        # byebug
        [decode, group_decoding]
      end

      def attempt_full_decode(coded_number_chars, connection, decoding, group_decoding)
        possible_values = MAPPING.select { |k, v| v.size == coded_number_chars.size }
        full_decoding = {}
        connection.each do |k, v|
          v.each do |value_to_decode|
            full_decoding[value_to_decode] ||= []
            full_decoding[value_to_decode] |= [k]
          end
        end

        possible_values.each do |possible_value, expected_chars|
          # expected_chars = MAPPING[possible_value]
          byebug
          all_options = build_all_options(coded_number_chars, full_decoding, expected_chars, group_decoding)
        end

        pp full_decoding
        pp possible_values
        byebug
        [decoding, group_decoding]
      end

      def build_all_options(coded_number_chars, full_decoding, expected_chars, group_decoding)
        all_possibilities = coded_number_chars.map { |char| full_decoding[char] }
        pp all_possibilities
        byebug
        a = 5
      end
    end

    class Puzzle8 < ::Aoc::PuzzleBase
      def initialize
        @entries = []
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @entries << CodedEntry.parse(line)
      end

      def unit_tests
        test_1 = 'acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf'
        test_1 = 'cefabd ab acedgfb cdfbe gcdfa fbcad dab cdfgeb eafb cagedb | cdfeb fcadb cdfeb cdbaf'
        test_2 = 'gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce'
        test_2 = 'gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce'

        assert_equal 5353, CodedEntry.parse(test_1).value
        # assert_equal 4315, CodedEntry.parse(test_2).value

      end
    end
  end
end
