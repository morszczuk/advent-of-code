module Aoc2022
  module Day8
    class Puzzle8B < Puzzle8
      def solve
        distances = calculate_distances(@grid)

        distances = distances.flatten(1)

        distances.map { |d| d.reduce(&:*) }.max
      end
    end
  end
end

