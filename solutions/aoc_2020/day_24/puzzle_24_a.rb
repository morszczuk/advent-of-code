module Aoc2020
  module Day24
    class Puzzle24A < Puzzle24
      def solve
        super()
        @floor.tiles.values.sum
      end
    end
  end
end
