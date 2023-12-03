module Aoc2023
  module Day3
    class Puzzle3 < ::Aoc::PuzzleBase
      def initialize
        @lines = []
        @elements = []
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @lines << line
        @elements << line.chars
      end

      def unit_tests
      end
    end
  end
end
