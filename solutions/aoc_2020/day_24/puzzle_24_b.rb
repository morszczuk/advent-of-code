module Aoc2020
  module Day24
    class Puzzle24B < Puzzle24
      def solve
        super
        100.times { @floor.day_passes }

        @floor.tiles.values.sum
      end
    end
  end
end

