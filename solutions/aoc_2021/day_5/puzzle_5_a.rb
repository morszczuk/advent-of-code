module Aoc2021
  module Day5
    class Puzzle5A < Puzzle5
      def solve
        super do |vectors|
          straight_lines = vectors.select(&:straight?)
        end
      end
    end
  end
end

