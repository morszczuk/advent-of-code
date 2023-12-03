module Aoc2023
  module Day3
    class Puzzle3B < Puzzle3
      def solve
        adjacent = Array.new(@lines.size) { Array.new(@lines.first.size) { false } }
        engine_id = 0

        @lines.each_with_index do |line, x|
          line.chars.each_with_index do |c, y|
            if c == '*'
              adjacent = add_to_adjacent(adjacent, x, y, engine_id)
              engine_id += 1
            end
          end
        end

        mapping = {}

        @lines.map.each_with_index do |line, x|
          number_positions = line.to_enum(:scan, /\d+/).map { last = Regexp.last_match; [last[0].to_i, last.offset(0)] }
          number_positions.each do |number, positions|
            res = adjacent[x][positions[0]...positions[1]].select { |e| e != false }
            unless res.empty?
              if mapping.key?(res.first)
                mapping[res.first] << number
              else
                mapping[res.first] = []
                mapping[res.first] << number
              end
            end
          end
        end
        mapping.values.select { |d| d.size > 1 }.map { |p| p.reduce(&:*) }.sum
      end

      def add_to_adjacent(adjacent, x, y, engine_id)
        adjacent[x - 1][y - 1] = engine_id
        adjacent[x][y - 1] = engine_id
        adjacent[x + 1][y - 1] = engine_id
        adjacent[x + 1][y] = engine_id
        adjacent[x + 1][y + 1] = engine_id
        adjacent[x][y + 1] = engine_id
        adjacent[x - 1][y + 1] = engine_id
        adjacent[x - 1][y] = engine_id

        adjacent
      end
    end
  end
end

