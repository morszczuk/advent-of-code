module Aoc2020
  module Day3
    class Puzzle3B < Puzzle3
      def solve
        slopes_to_count_trees = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]

        slopes_to_count_trees.map! do |movement|
          MapTraverser.new(@map_sample, *movement).traverse
        end.reduce(&:*)
      end
    end
  end
end

