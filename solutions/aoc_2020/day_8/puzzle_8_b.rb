module Aoc2020
  module Day8
    class Puzzle8B < Puzzle8
      def solve
        DeviceFixer.new(@device.instructions).call
      end
    end
  end
end
