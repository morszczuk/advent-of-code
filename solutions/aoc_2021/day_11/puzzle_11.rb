module Aoc2021
  module Day11
    class Array2D
      def initialize
        @array = []
      end

      def add_row(row)
        @array << row
      end

      def to_s
        @array.to_s
      end

      def each_elem
        @array.each_with_index do |row, y|
          row.each_with_index do |elem, x|
            yield elem, y, x
          end
        end
      end

      def width
        @array.first.size
      end

      def height
        @array.size
      end

      def size
        width * height
      end

      def adjacent_coords(x, y)
        on_left = x > 0 ? [x - 1, y] : nil
        on_right = x < width - 1 ? [x + 1, y] : nil
        on_top = y > 0 ? [x, y - 1] : nil
        on_bottom = y < height - 1 ? [x, y + 1] : nil

        [on_left, on_top, on_right, on_bottom].compact
      end

      def surrounding_coords(x, y)
        xs = ([0, x - 1].max..[width - 1, x + 1].min)
        ys = ([0, y - 1].max..[height - 1, y + 1].min)
        xs.to_a.product(ys.to_a) - [[x,y]]
      end

      def value(x, y)
        @array[y][x]
      end

      def set_value(x, y, val)
        @array[y][x] = val
      end
    end

    class Puzzle11 < ::Aoc::PuzzleBase
      def initialize
        @octopussies = Array2D.new
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @octopussies.add_row line.chars.map(&:to_i)
      end

      def step(octopussies)
        flashes = {}
        octopussies.each_elem do |elem, x, y|
          handle_elem(x, y, octopussies, flashes)
        end

        [octopussies, flashes.keys.size]
      end

      def handle_elem(x, y, octopussies, flashed)
        elem = octopussies.value(x, y)
        case elem
        when 9
          return [octopussies, flashed] if flashed.key? [x,y]

          octopussies.set_value(x, y, 0)
          flashed[[x,y]] = true
          (octopussies.surrounding_coords(x, y) - flashed.keys).each do |coords|
            octopussies, flashed = handle_elem(coords.first, coords.last, octopussies, flashed)
          end
        else
          return [octopussies, flashed] if flashed.key? [x,y]

          octopussies.set_value(x, y, octopussies.value(x, y) + 1)
        end

        [octopussies, flashed]
      end

      def unit_tests
      end
    end
  end
end
