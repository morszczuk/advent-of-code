module Aoc2020
  module Day22
    class Puzzle22A < Puzzle22
      def solve
        Game.new(@decks).play
      end
    end
  end
end
