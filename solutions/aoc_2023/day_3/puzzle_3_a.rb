module Aoc2023
  module Day3
    class Puzzle3A < Puzzle3
      def solve
        adjacent = Array.new(@lines.size) { Array.new(@lines.first.size) { false } }

        @lines.each_with_index do |line, x|
          line.chars.each_with_index do |c, y|
            if !/\d/.match(c) && c != '.'
              adjacent = add_to_adjacent(adjacent, x, y)
            end
          end
        end

        @lines.map.each_with_index do |line, x|
          number_positions = line.to_enum(:scan, /\d+/).map { last = Regexp.last_match; [last[0].to_i, last.offset(0)] }
          number_positions.select do |number, positions|
            adjacent[x][positions[0]...positions[1]].any? { |e| e }
          end.map(&:first)
        end.flatten.sum
      end

      def add_to_adjacent(adjacent, x, y)
        adjacent[x - 1][y - 1] = true
        adjacent[x][y - 1] = true
        adjacent[x + 1][y - 1] = true
        adjacent[x + 1][y] = true
        adjacent[x + 1][y + 1] = true
        adjacent[x][y + 1] = true
        adjacent[x - 1][y + 1] = true
        adjacent[x - 1][y] = true

        adjacent
      end
    end
  end
end

