module Aoc2021
  module Day1
    class Puzzle1 < ::Aoc::PuzzleBase
      def initialize
        @measurements = []
        super()
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @measurements << line.to_i
      end

      def unit_tests
      end
    end
  end
end
