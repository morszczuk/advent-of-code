module Aoc2023
  module Day2
    class Puzzle2B < Puzzle2
      def solve
        colors = ['red', 'green', 'blue']

        @games.values.map do |game|
          colors.map do |color|
            game.map {|set| set[color] }.compact.max
          end.reduce(:*)
        end.sum
      end
    end
  end
end

