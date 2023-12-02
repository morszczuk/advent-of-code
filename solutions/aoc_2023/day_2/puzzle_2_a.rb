module Aoc2023
  module Day2
    class Puzzle2A < Puzzle2
      def solve
        limits = {
          'red' => 12,
          'green' => 13,
          'blue' => 14
        }

        @games.select do |k, v|
          v.all? do |set|
            set.all? do |color, val|
              val <= limits[color]
            end
          end
        end.keys.sum
      end
    end
  end
end

