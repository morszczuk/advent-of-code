module Aoc2022
  module Day4
    class Puzzle4 < ::Aoc::PuzzleBase
      def initialize
        @pairs = []
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @pairs << line.split(',').map { |s| s.split('-').map(&:to_i) }
      end

      def unit_tests
      end
    end
  end
end
