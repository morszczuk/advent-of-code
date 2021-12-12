module Aoc2021
  module Day12
    class Puzzle12A < Puzzle12
      def solve
        PathFinder.new(@graph, @nodes).find_all_paths.count
      end
    end
  end
end

