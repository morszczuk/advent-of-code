module Aoc2020
  module Day10
    class JoltageRatings
      attr_accessor :data

      def initialize
        @data = [0]
      end

      def add_elem(elem)
        @data << elem
      end

      def finish_creation!
        @data.sort!
        @data << @data.last + 3
      end
    end

    class DifferenceEstablisher
      attr_accessor :result

      def initialize(input)
        @input = input
        @result = Hash.new(0)
      end

      def call
        @input.each_cons(2) do |elem_1, elem_2|
          @result[elem_2 - elem_1] += 1
        end

        @result
      end
    end

    class AllPossibleArrangementsCounter
      def initialize(input)
        @input = input
        @diffs = determine_diffs

        @current_pattern = 0
      end

      def call
        @patterns_count = count_sub_patterns
        @patterns_count.map do |pattern_length, amount|
          if pattern_length > 1
            n = pattern_length - 1
            k_s = (0..(n))

            combination_sum = k_s.map { |k| combination(n, k) }.inject(&:+)
            incorrect_cases = n >= 3 ? 3.pow(n - 3) : 0

            (combination_sum - incorrect_cases).pow(amount)
          else
            1
          end
        end.inject(&:*)
      end

      def count_sub_patterns
        sub_patterns_count = Hash.new(0)

        @diffs.each do |current_elem|
          if current_elem == 1
            @current_pattern += 1
          elsif @current_pattern.positive?
            sub_patterns_count[@current_pattern] += 1
            @current_pattern = 0
          end
        end

        sub_patterns_count
      end

      def determine_diffs
        @input.each_cons(2).map do |elem_1, elem_2|
          elem_2 - elem_1
        end
      end

      def combination(n, k)
        factorial(n) / (factorial(n -k) * factorial(k))
      end

      def factorial(n)
        return nil if n.negative?

        value = 1
        while n.positive?
          value *= n
          n -= 1
        end

        value
      end
    end

    class Puzzle10 < ::Aoc::PuzzleBase
      def initialize
        @joltage_ratings = JoltageRatings.new
        super()
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line)
        @joltage_ratings.add_elem(line.to_i)
      end

      def unit_tests
      end
    end
  end
end
