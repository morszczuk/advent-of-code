module Aoc2021
  module Day1
    class Puzzle1B < Puzzle1
      def solve
        @measurements.each_cons(3).map(&:sum).each_cons(2).count { |a, b| a < b }
      end
    end
  end
end

