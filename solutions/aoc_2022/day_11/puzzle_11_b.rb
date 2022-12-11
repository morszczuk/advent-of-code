module Aoc2022
  module Day11
    class Puzzle11B < Puzzle11
      def solve
        monkey_divisions = @monkeys.map(&:divide_test).reduce(:*)
        monkey_business(10000) { |stress| stress % monkey_divisions }
      end
    end
  end
end

# 30616425600
