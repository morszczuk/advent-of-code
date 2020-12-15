module Aoc2020
  module Day15
    class Puzzle15A < Puzzle15
      def solve
        MemoryGame.new(@starting_numbers).play_for(rounds: 2020)
      end
    end
  end
end
