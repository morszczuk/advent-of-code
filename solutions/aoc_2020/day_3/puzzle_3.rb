module Aoc2020
  module Day3
    class MapTraverser
      attr_reader :steps_count

      def initialize(map_sample, movement_x = 3, movement_y = 1)
        @map_sample = map_sample
        @map_accessor = MapAccessor.new(@map_sample)
        @trees_count = 0
        @steps_count = 0
        @position = [0, 0]
        @movement = [movement_x, movement_y]
      end

      def traverse
        make_step until end_of_map?

        @trees_count
      end

      def end_of_map?
        @position[1] == @map_sample.height - 1
      end

      def make_step
        @position = [@position, @movement].transpose.map(&:sum)
        value = @map_accessor.element_at(*@position)
        @steps_count += 1
        @trees_count += value
      end
    end

    class MapSample
      SQUARE = 0
      TREE = 1

      attr_accessor :sample

      def initialize()
        @sample = []
      end

      def [](x, y)
        @sample[y][x]
      end

      def width
        @width ||= @sample.first.size
      end

      def height
        @height ||= @sample.size
      end

      def parse_line(line)
        @sample << line.split('').map!(&method(:identify_element)).compact
      end

      private

      def identify_element(element)
        case element
        when '.' then SQUARE
        when '#' then TREE
        end
      end
    end

    class MapAccessor
      def initialize(map_sample)
        @map_sample = map_sample
        @sample_width = @map_sample.width
      end

      def element_at(x, y)
        sample_x = calculate_sample_x(x)

        @map_sample[sample_x, y]
      end

      def calculate_sample_x(x)
        x % @sample_width
      end
    end

    class Puzzle3 < ::Aoc::PuzzleBase
      def initialize
        @map_sample = MapSample.new
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line)
        @map_sample.parse_line(line)
      end

      def unit_tests
      end
    end
  end
end
