module Aoc2021
  module Day1
    class Puzzle1A < Puzzle1
      def solve
        increases = []
        @measurements.each_cons(2) do |a, b|
          increases << b if b > a
        end
        increases.count
      end
    end
  end
end

