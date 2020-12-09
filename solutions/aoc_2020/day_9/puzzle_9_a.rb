module Aoc2020
  module Day9
    class Puzzle9A < Puzzle9
      def solve
        FirstNotWorkingElementAfterPreambleFinder.new(@input.data, preamble_size: 25).call
      end
    end
  end
end

