module Aoc2022
  module Day11
    class Puzzle11A < Puzzle11
      def solve
        monkey_business(20) { |stress| stress / 3 }
      end
    end
  end
end

# 117640
