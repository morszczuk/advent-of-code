module Aoc2020
  module Day13
    class Puzzle13 < ::Aoc::PuzzleBase
      attr_reader :starting_time, :buses

      def initialize
        super()
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, index)
        if index.zero?
          @starting_time = line.to_i
        else
          @buses = line.split(',').each_with_index.map { |e, order| [e.to_i, order] }.reject { |e| e.first.zero? }
        end
      end

      def unit_tests
      end
    end
  end
end
