module Aoc2020
  module Day12
    class Puzzle12A < Puzzle12
      def initialize
        @move_translator = CommandTranslator
        @ship = MovingObject.new
        super()
      end

      def solve
        ManhattanDistance.call([0, 0], @ship.position)
      end
    end
  end
end

