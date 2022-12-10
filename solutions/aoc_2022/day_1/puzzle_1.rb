module Aoc2022
  module Day1
    class Puzzle1 < ::Aoc::PuzzleBase
      def initialize
        @deers = [[]]
        @new_item = false
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        if line.empty?
          @deers << []
        else
          @deers.last << line.to_i
        end
      end

      def unit_tests
      end
    end
  end
end
