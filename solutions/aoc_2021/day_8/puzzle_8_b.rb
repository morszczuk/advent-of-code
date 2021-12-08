module Aoc2021
  module Day8
    class Puzzle8B < Puzzle8
      def solve
        @entries.map(&:decoded_output_values).sum
      end
    end
  end
end

