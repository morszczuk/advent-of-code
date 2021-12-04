module Aoc2021
  module Day3
    class Puzzle3 < ::Aoc::PuzzleBase
      def initialize
        @numbers = []
        @gamma_rate = {}
        # @gamma_rate = Hash.new({ '0' => 0, '1' => 0})
        # @epsilon_rate = Hash.new({ '0' => 0, '1' => 0})
        @epsilon_rate = {}
        super
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @numbers << line
      end

      def unit_tests
      end

      def set_rate(chars, rate)
        chars.each_with_index do |bit, index|
          rate[index] ||= { '0' => 0, '1' => 0}
          rate[index][bit] += 1
        end

        rate
      end
    end
  end
end
