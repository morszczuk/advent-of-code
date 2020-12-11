module Aoc2020
  module Day11
    class Puzzle11B < Puzzle11
      def solve
        HumanFloorAssigner.new(@floor_layout, ClosestSeatMover).call
      end
    end
  end
end
