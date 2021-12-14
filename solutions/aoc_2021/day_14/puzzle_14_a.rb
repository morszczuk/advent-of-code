module Aoc2021
  module Day14
    class Puzzle14A < Puzzle14
      def solve
        pp count_polymer_difference(@template, 10)
        pp count_polymer_difference(@template, 10) == (alt_res = alternative_count_polymer_difference(@template, 10))
        alt_res
      end
    end
  end
end

