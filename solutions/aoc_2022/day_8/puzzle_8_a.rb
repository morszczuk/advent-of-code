module Aoc2022
  module Day8
    class Puzzle8A < Puzzle8
      def solve
        visible_matrix = mark_visible_matrix(@input)
        visible_matrix.sum
      end
    end
  end
end
