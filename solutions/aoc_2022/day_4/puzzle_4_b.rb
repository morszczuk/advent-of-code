module Aoc2022
  module Day4
    class Puzzle4B < Puzzle4
      def solve
        @pairs.select do |pair_1, pair_2|
          any_overlap?(pair_1, pair_2) || any_overlap?(pair_2, pair_1)
        end.count
      end

      def any_overlap?(pair_1, pair_2)
        pair_1[1] >= pair_2[0] && pair_1[1] <= pair_2[1]
      end
    end
  end
end

