module Aoc2022
  module Day3
    class Puzzle3B < Puzzle3
      def solve
        common = @elems.each_slice(3).map do |slice|
          (slice[0] & slice [1] & slice[2]).first
        end
        priority_value(common)
      end
    end
  end
end

