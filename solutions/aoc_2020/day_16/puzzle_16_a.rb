module Aoc2020
  module Day16
    class Puzzle16A < Puzzle16
      def solve
        @nearby_tickets.map { |t| t.validate(@rules) }.flatten.sum
      end
    end
  end
end

