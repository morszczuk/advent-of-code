require 'matrix'

module Aoc2022
  module Day8
    class Puzzle8 < ::Aoc::PuzzleBase
      def initialize
        @grid = []
      end

      def solve
        raise 'Not defined'
      end

      def calculate_distances(grid)
        distances = Array.new(grid.size) { Array.new(grid.size) { [0, 0, 0, 0] }}

        grid.size.times do |row|
          grid.size.times do |col|
            distances[row][col][0] = left_dist(grid, row, col)
            distances[row][col][1] = right_dist(grid, row, col)
            distances[row][col][2] = top_dist(grid, row, col)
            distances[row][col][3] = bottom_dist(grid, row, col)
          end
        end

        distances
      end

      def left_dist(grid, row, col)
        return 0 if col == 0


        dist = 1
        col.times do |i|
          return dist if grid[row][col - i - 1] >= grid[row][col]

          dist +=1
        end

        dist - 1
      end

      def right_dist(grid, row, col)
        return 0 if col == grid.size - 1

        dist = 1
        (grid.size - 1 - col).times do |i|
          return dist if grid[row][col + i + 1] >= grid[row][col]

          dist +=1
        end

        dist - 1
      end

      def top_dist(grid, row, col)
        return 0 if row == 0

        dist = 1
        row.times do |i|
          return dist if grid[row - i - 1][col] >= grid[row][col]

          dist +=1
        end

        dist - 1
      end

      def bottom_dist(grid, row, col)
        return 0 if row == grid.size - 1

        dist = 1
        (grid.size - 1 - row).times do |i|
          return dist if grid[row + i + 1][col] >= grid[row][col]

          dist +=1
        end

        dist - 1
      end

      def mark_visible(visible, grid)
        visible = Array.new(grid.size) { Array.new(grid.size) { 0 }}

        left = Array.new(grid.size) { Array.new(grid.size) { 0 }}
        right = Array.new(grid.size) { Array.new(grid.size) { 0 }}
        top = Array.new(grid.size) { Array.new(grid.size) { 0 }}
        bottom = Array.new(grid.size) { Array.new(grid.size) { 0 }}

        grid.size.times do |row|
          grid.size.times do |col|
            if col == 0
              prev = 0
              prev_left = 0
            else
              prev = grid[row][col-1]
              prev_left = left[row][col-1]
            end
            left[row][col] = [prev, prev_left, 0].max
          end
        end

        grid.size.times do |row|
          grid.size.times do |col|
            if row == 0
              prev = 0
              prev_top = 0
            else
              prev = grid[row - 1][col]
              prev_top = top[row - 1][col]
            end
            top[row][col] = [prev, prev_top, 0].max
          end
        end

        grid.size.times do |row|
          grid.size.times do |col|
            if col == 0
              prev = 0
              prev_right = 0
            else
              prev = grid[row][grid.size - col]
              prev_right = right[row][grid.size - col]
            end
            right[row][grid.size - col -1 ] = [prev, prev_right, 0].max
          end
        end

        grid.size.times do |row|
          grid.size.times do |col|
            if row == 0
              prev = 0
              prev_bottom = 0
            else
              prev = grid[grid.size - row][col]
              prev_bottom = bottom[grid.size - row][col]
            end
            bottom[grid.size - row -1][col] = [prev, prev_bottom, 0].max
          end
        end

        grid.size.times do |row|
          grid.size.times do |col|
            if is_edge?(row, col, grid.size)
              visible[row][col] = 1
            else
              visible[row][col] = 1 if seen_from_edge?(row, col, grid, left, right, top, bottom)
            end
          end
        end

        visible
      end

      def mark_visible_matrix(matrix)
        grid_size = matrix.row_size

        visible_matrix = Matrix.build(grid_size) { 0 }

        left_matrix = Matrix.build(grid_size) { 0 }
        top_matrix = Matrix.build(grid_size) { 0 }
        right_matrix = Matrix.build(grid_size) { 0 }
        bottom_matrix = Matrix.build(grid_size) { 0 }

        matrix.each_with_index do |e, row, col|
          if col == 0
            prev = 0
            prev_left = 0
          else
            prev = matrix[row, col-1]
            prev_left = left_matrix[row, col-1]
          end
          left_matrix[row, col] = [prev, prev_left, 0].max
        end

        matrix.each_with_index do |e, row, col|
          if row == 0
            prev = 0
            prev_top = 0
          else
            prev = matrix[row - 1, col]
            prev_top = top_matrix[row - 1, col]
          end
          top_matrix[row, col] = [prev, prev_top, 0].max
        end

        matrix.each_with_index do |e, row, col|
          if col == 0
            prev = 0
            prev_right = 0
          else
            prev = matrix[row, grid_size - col]
            prev_right = right_matrix[row , grid_size - col]
          end
          right_matrix[row, grid_size - col - 1] = [prev, prev_right, 0].max
        end

        matrix.each_with_index do |e, row, col|
          if row == 0
            prev = 0
            prev_bottom = 0
          else
            prev = matrix[grid_size - row, col]
            prev_bottom = bottom_matrix[grid_size - row, col]
          end
          bottom_matrix[grid_size - row - 1, col] = [prev, prev_bottom, 0].max
        end

        matrix.each_with_index do |e, row, col|
          if is_edge?(row, col, grid_size)
            visible_matrix[row, col] = 1
          else
            visible_matrix[row, col] = 1 if seen_from_matrix_edge?(row, col, matrix, left_matrix, right_matrix, top_matrix, bottom_matrix)
          end
        end

        visible_matrix
      end

      def is_edge?(row, col, size)
        row == 0 || row == size -1 || col == 0 || col == size -1
      end

      def seen_from_edge?(row, col, grid, left, right, top, bottom)
        grid[row][col] > left[row][col] ||
        grid[row][col] > right[row][col] ||
        grid[row][col] > top[row][col] ||
        grid[row][col] > bottom[row][col]
      end

      def seen_from_matrix_edge?(row, col, grid, left, right, top, bottom)
        grid[row, col] > left[row, col] ||
        grid[row, col] > right[row, col] ||
        grid[row, col] > top[row, col] ||
        grid[row, col] > bottom[row, col]
      end

      class MatrixInput
        def initialize(item_type: :number)
          @elem_type = :number
        end

        def parse(input_filename)
          lines = File.readlines(input_filename).map(&:strip!).map(&:chars)
          lines = lines.map { |line| line.map(&:to_i) } if @elem_type == :number

          Matrix[*lines]
        end
      end

      @@input_handler = nil

      def self.input_handler
        @@input_handler
      end

      def self.input_handler=(input_handler)
        @@input_handler = input_handler
      end

      def self.input(type, **arg)
        case type
        when :matrix
          @@input_handler = MatrixInput.new(**arg)
        end
      end

      input :matrix, item_type: :number

      def handle_input_line(line, *_args)
        @grid << line.chars.map(&:to_i)
      end

      def unit_tests
      end
    end
  end
end
