module Aoc2021
  module Day11
    class Puzzle11B < Puzzle11
      def solve
        all_flashes_count = @octopussies.size
        octopussies = @octopussies
        step = 0
        while true do
          step += 1
          octopussies, flashes = step(octopussies)
          return step if flashes == all_flashes_count
        end
      end
    end
  end
end

