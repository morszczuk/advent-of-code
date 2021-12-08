module Aoc2021
  module Day8
    class Puzzle8A < Puzzle8
      def solve
        @entries.map(&:recognizeble_numbers).sum(&:size)
      end
    end
  end
end

