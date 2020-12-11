module Aoc2020
  module Day11
    class Puzzle11A < Puzzle11
      def solve
        HumanFloorAssigner.new(@floor_layout, AdjacentRuleSeatMover).call
      end
    end
  end
end
