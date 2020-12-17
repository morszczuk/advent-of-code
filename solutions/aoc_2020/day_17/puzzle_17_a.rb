module Aoc2020
  module Day17
    class Puzzle17A < Puzzle17
      def solve
        super do |current_pocket|
          Move.new(current_pocket).make
        end
      end
    end
  end
end
