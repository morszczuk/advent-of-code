module Aoc2022
  module Day3
    class Puzzle3A < Puzzle3
      def solve
        common = @elems.map do |elem|
          e1, e2 = elem.in_groups(2)
          (e1 & e2).first
        end

        priority_value(common)
      end
    end
  end
end

