module Aoc2023
  module Day1
    class Puzzle1A < Puzzle1
      def solve
        regex = /\d/
        @inputs.map do |line|
          "#{regex.match(line)}#{regex.match(line.reverse)}".to_i
        end.sum
      end
    end
  end
end

