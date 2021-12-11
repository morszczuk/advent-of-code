module Aoc2021
  module Day9
    class Puzzle9A < Puzzle9
      def solve
        lowpoints = find_all_lowpoints
        lowpoints.map(&:last).sum + lowpoints.size
      end
    end
  end
end

