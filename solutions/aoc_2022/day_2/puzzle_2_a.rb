module Aoc2022
  module Day2
    class Puzzle2A < Puzzle2
      def solve
        @strategy.map do |opp, me|
          result_scoe(result(opp, me)) + VAL[me]
        end.sum
      end
    end
  end
end

