module Aoc2022
  module Day4
    class Puzzle4A < Puzzle4
      def solve
        @pairs.select do |pair_1, pair_2|
          (pair_1[0] >= pair_2[0] && pair_1[1] <= pair_2[1]) ||
            (pair_2[0] >= pair_1[0] && pair_2[1] <= pair_1[1])
        end.count
      end
    end
  end
end

