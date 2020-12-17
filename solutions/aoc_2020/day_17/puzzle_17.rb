module Aoc2020
  module Day17
    class Move
      attr_accessor :new_max_x, :new_max_y, :new_min_x, :new_min_y

      def initialize(previous_world, include_w: false)
        @previous_world = previous_world
        @include_w = include_w

        @new_world = @previous_world.deep_dup

        @dimension_ranges = (0..3).map do |dimension_id|
          (@previous_world.min_in_dimension(dimension_id) - 1)..((@previous_world.max_in_dimension(dimension_id) + 1))
        end

        @dimension_ranges[3] = [0] unless include_w
      end

      def make
        @dimension_ranges[0].each do |x|
          @dimension_ranges[1].each do |y|
            @dimension_ranges[2].each do |z|
              @dimension_ranges[3].each do |w|
                @new_world[[x, y, z, w]] = new_cube_value(x, y, z, w)
              end
            end
          end
        end

        @new_world
      end

      def new_cube_value(x, y, z, w)
        previous_cube_activity = @previous_world.value_at(x, y, z, w)
        active_neighbours_count = @previous_world.count_active_neighbours(x, y, z, w, include_w: @include_w)

        if previous_cube_activity == 1 && active_neighbours_count != 2 && active_neighbours_count != 3
          0
        elsif previous_cube_activity == 0 && active_neighbours_count == 3
          1
        else
          previous_cube_activity
        end
      end
    end

    class Pocket < Hash
      def value_at(x, y, z, w)
        self[[x, y, z, w]] = 0 if self[[x, y, z, w]].nil?

        self[[x, y, z, w]]
      end

      def count_active_neighbours(x, y, z, w, include_w: false)
        (x - 1..x + 1).sum do |xx|
          (y - 1..y + 1).sum do |yy|
            (z - 1..z + 1).sum do |zz|
              if include_w
                (w - 1..w + 1).sum do |ww|
                  [xx, yy, zz, ww] == [x, y, z, w] ? 0 : value_at(xx, yy, zz, ww)
                end
              else
                [xx, yy, zz, 0] == [x, y, z, 0] ? 0 : value_at(xx, yy, zz, 0)
              end
            end
          end
        end
      end

      def min_in_dimension(dimension_id)
        keys.map { |dimensions| dimensions[dimension_id] }.min
      end

      def max_in_dimension(dimension_id)
        keys.map { |dimensions| dimensions[dimension_id] }.max
      end
    end

    class Puzzle17 < ::Aoc::PuzzleBase
      POCKET_MOVES_COUNT = 6

      def initialize
        @initial_world_cubes = []
        super()
      end

      def solve
        pocket = Pocket.new

        @initial_world_cubes.each_with_index do |row, x|
          row.each_with_index do |cube, y|
            pocket[[x, y, 0, 0]] = cube
          end
        end

        POCKET_MOVES_COUNT.times do
          pocket = yield(pocket)
        end

        pocket.values.sum
      end

      def handle_input_line(line, *_args)
        @initial_world_cubes << line.tr('.', '0').tr('#', '1').split('').map(&:to_i)
      end
    end
  end
end
