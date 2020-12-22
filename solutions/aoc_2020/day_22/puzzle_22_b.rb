module Aoc2020
  module Day22
    class Puzzle22B < Puzzle22
      def solve
        RecursiveGame.new(@decks).play.second
      end
    end
  end
end
