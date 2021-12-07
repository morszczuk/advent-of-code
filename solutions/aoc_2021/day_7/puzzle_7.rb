module Aoc2021
  module Day7
    class Puzzle7 < ::Aoc::PuzzleBase
      def initialize
        super
      end

      def solve
        existence = @crabs.tally
        min = nil
        (existence.keys.min..existence.keys.max).each do |val|
          current = existence.sum { |k, v| yield(k, v, val) }
          min = current if min.nil? || current < min
        end

        min
      end

      def handle_input_line(line, *_args)
        @crabs = line.split(',').map(&:to_i)
      end

      def unit_tests
      end
    end
  end
end
