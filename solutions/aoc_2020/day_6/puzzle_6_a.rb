module Aoc2020
  module Day6
    class Puzzle6A < Puzzle6
      def solve
        @groups.map(&:uniq_forms_count).sum
      end
    end
  end
end

