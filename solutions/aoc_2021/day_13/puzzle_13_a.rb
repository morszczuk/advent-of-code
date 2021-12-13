module Aoc2021
  module Day13
    class Puzzle13A < Puzzle13
      def solve
        fold(@card, *@folds.first).count
      end
    end
  end
end

