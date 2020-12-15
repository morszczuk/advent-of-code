module Aoc2020
  module Day15
    class Puzzle15B < Puzzle15
      def solve
        MemoryGame.new(@starting_numbers).play_for(rounds: 30_000_000)
      end
    end
  end
end

