module Aoc2021
  module Day9
    class Puzzle9 < ::Aoc::PuzzleBase
      def initialize
        @heightmap = []
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @heightmap << line.chars.map(&:to_i)
      end

      def find_all_lowpoints
        horizontal_lowpoints = find_lowpoints(@heightmap)
        vertical_lowpoints = find_lowpoints(@heightmap.transpose, true)

        lowpoints = horizontal_lowpoints.to_a & vertical_lowpoints.to_a
      end

      def find_lowpoints(heightmap, transposed = false)
        lowpoints = {}

        heightmap.each_with_index do |row, y|
          row.each_with_index do |elem, x|
            is_lowpoint_left = true
            is_lowpoint_right = true
            is_lowpoint_left = elem < heightmap[y][x - 1] unless x ==0
            is_lowpoint_right = elem < heightmap[y][x + 1] unless x == row.size - 1
            coord = transposed ? [y, x] : [x, y]
            lowpoints[coord] = elem if is_lowpoint_left && is_lowpoint_right
          end
        end

        lowpoints
      end

      def unit_tests
      end
    end
  end
end
