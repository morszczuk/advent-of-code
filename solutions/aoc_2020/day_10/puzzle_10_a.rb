module Aoc2020
  module Day10
    class Puzzle10A < Puzzle10
      def solve
        @joltage_ratings.finish_creation!
        number_of_diffs = DifferenceEstablisher.new(@joltage_ratings.data).call

        number_of_diffs[3] * number_of_diffs[1]
      end
    end
  end
end

