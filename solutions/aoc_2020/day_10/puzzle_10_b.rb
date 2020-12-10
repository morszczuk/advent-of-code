module Aoc2020
  module Day10
    class Puzzle10B < Puzzle10
      def solve
        @joltage_ratings.finish_creation!

        AllPossibleArrangementsCounter.new(@joltage_ratings.data).call
      end
    end
  end
end

