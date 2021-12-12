module Aoc2021
  module Day12
    class Puzzle12B < Puzzle12
      def solve
        PathFinder.new(@graph, @nodes).find_all_paths(true).count
      end
    end
  end
end

