module Aoc2021
  module Day7
    class Puzzle7B < Puzzle7
      def solve
        super &method(:distance_sum)
      end

      def distance_sum(k, v, val)
        ((k-val).abs + 1).times.sum * v
      end
    end
  end
end

