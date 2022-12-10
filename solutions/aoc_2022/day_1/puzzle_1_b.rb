module Aoc2022
  module Day1
    class Puzzle1B < Puzzle1
      def solve
        @deers.map(&:sum).sort.last(3).sum
      end
    end
  end
end

