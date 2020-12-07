module Aoc2020
  module Day6
    class Puzzle6B < Puzzle6
      def solve
        @groups.map(&:all_yes_count).sum
      end
    end
  end
end

