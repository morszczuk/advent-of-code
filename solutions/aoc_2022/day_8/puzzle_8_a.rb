module Aoc2022
  module Day8
    class Puzzle8A < Puzzle8
      def solve
        visible = mark_visible(@visible, @grid)
        visible.sum { |row| row.sum }
      end
    end
  end
end
