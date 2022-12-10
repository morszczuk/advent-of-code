module Aoc2022
  module Day1
    class Puzzle1A < Puzzle1
      def solve
        @deers.max_by(&:sum).sum
      end
    end
  end
end

