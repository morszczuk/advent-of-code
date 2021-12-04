module Aoc2021
  module Day3
    class Puzzle3B < Puzzle3
      def solve
        rate_sets = {}

        @numbers.each do |number|
          rate_sets = set_rate(number.chars, rate_sets)
        end

        # numbers = @numbers.map(&:chars).map(&:reverse!).map
        numbers = @numbers.map(&:chars).map
        size = numbers.first.size

        # oxygen = (size - 1).times.reduce(@numbers) do |current_set, n|
        oxygen = size.times.reduce(numbers) do |current_set, n|
          next current_set if current_set.size == 1

          char = leading_char(current_set, n)

          # pp "Leading char : #{char}"

          current_set.select { |elem| elem[n] == char }
        end

        scrubber = size.times.reduce(numbers) do |current_set, n|
          next current_set if current_set.size == 1

          char = leading_char_2(current_set, n)

          pp "Leading char : #{char}"

          current_set.select { |elem| elem[n] == char }
        end

        # byebug
        pp 'Oxyegn'
        pp oxygen.first
        pp (oxygen = oxygen.first.join('').to_i(2))
        pp 'Scrubber'
        pp scrubber.first
        pp (scrubber = scrubber.first.join('').to_i(2))

        oxygen * scrubber



        # leading_chars = prepare_leading_chars(rate_sets)
      end

      def leading_char(set, position)
        leading_chars = set.map { |num| num[position] }

        # pp set
        # pp set.count

        char_1 = leading_chars.count { |e| e == '1' }
        char_2 = leading_chars.count { |e| e == '0' }

        # byebug

        char_1 >= char_2 ? '1' : '0'

        # byebug
      end

      def leading_char_2(set, position)
        leading_chars = set.map { |num| num[position] }

        pp set
        pp set.count

        char_1 = leading_chars.count { |e| e == '1' }
        char_2 = leading_chars.count { |e| e == '0' }

        pp 'Char 1'
        pp char_1
        pp 'Char 2'
        pp char_2

        char_2 <= char_1 ? '0' : '1'

        # byebug
      end

      def prepare_leading_chars(rate_sets)
        rate_sets.map do |key, value|
          [key, value.to_a.min { |a, b| a.last <=> b.last }.first]
        end.join('')
      end
    end
  end
end

