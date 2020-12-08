module Aoc2020
  module Day8
    class Puzzle8A < Puzzle8
      def solve
        DeviceRunner.new(@device.instructions).call[:value]
      end
    end
  end
end

