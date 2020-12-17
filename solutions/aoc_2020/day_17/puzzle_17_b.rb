module Aoc2020
  module Day17
    class Puzzle17B < Puzzle17
      def solve
        super do |current_pocket|
          Move.new(current_pocket, include_w: true).make
        end
      end
    end
  end
end
