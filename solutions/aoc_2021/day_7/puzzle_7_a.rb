module Aoc2021
  module Day7
    class Puzzle7A < Puzzle7
      def solve
        super &method(:distance)
      end

      def distance(k, v, val)
        (val-k).abs * v
      end
    end
  end
end

