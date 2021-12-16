module Aoc2021
  module Day15
    class Puzzle15 < ::Aoc::PuzzleBase
      def initialize
        @map =  Aoc::Array2D.new
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @map.add_row(line.chars.map(&:to_i))
      end

      def unit_tests
      end
    end
  end
end
