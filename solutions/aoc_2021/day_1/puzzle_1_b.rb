module Aoc2021
  module Day1
    class Puzzle1B < Puzzle1
      def solve
        group_sums = []
        @measurements.each_cons(3) do |a, b, c|
          group_sums << a + b + c
        end
        increases = 0
        group_sums.each_cons(2) do |a, b|
          increases += 1 if b > a
        end
        increases
      end
    end
  end
end

