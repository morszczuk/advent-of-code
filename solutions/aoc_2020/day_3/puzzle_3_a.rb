module Aoc2020
  module Day3
    class Puzzle3A < Puzzle3
      def solve
        MapTraverser.new(@map_sample).traverse
      end
    end
  end
end

