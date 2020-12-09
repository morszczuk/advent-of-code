module Aoc2020
  module Day9
    class Puzzle9B < Puzzle9
      def solve
        ContingenceFinder.new(@input.data, 776203571).call
      end
    end
  end
end

