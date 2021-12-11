module Aoc2021
  module Day11
    class Puzzle11A < Puzzle11
      def solve
        steps = 100
        octopussies = @octopussies
        total_flashes = 0
        steps.times do
          octopussies, flashes = step(octopussies)
          total_flashes += flashes
        end
        total_flashes
      end
    end
  end
end

