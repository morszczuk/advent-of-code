module Aoc2020
  module Day24
    class Floor
      attr_reader :visited_tiles, :tiles

      DIR_CHANGES = {
        'e' => [1, -1, 0],
        'se' => [0, -1, 1],
        'ne' => [1, 0, -1],
        'w' => [-1, 1, 0],
        'nw' => [0, 1, -1],
        'sw' => [-1, 0, 1],
      }

      def initialize
        @tiles = Hash.new { 0 }
        @tiles[[0, 0, 0]] = 0 # 0 is white
      end

      def follow_path(path)
        @current_tile_id = [0, 0, 0]
        previous_double = false
        path.chars.each_cons(2) do |first, second|
          if %w[s n].include?(first)
            next_tile_dir = "#{first}#{second}"
            previous_double = true
          elsif previous_double
            previous_double = false
            next
          else
            next_tile_dir = first
            previous_double = false
          end

          @current_tile_id = new_id(@current_tile_id, next_tile_dir)
        end

        if %w[e w].include? path.chars[-2]
          @current_tile_id = new_id(@current_tile_id, path.chars[-1])
        end

        @tiles[@current_tile_id] = flip(@tiles[@current_tile_id])
      end

      def day_passes
        new_tiles = Hash.new { 0 }
        @tiles.select { |_id, color| color == 1 }.each do |id, color|
          neighbour_ids = identify_neighbour_ids(id)
          new_tiles[id] = identify_new_color(color, neighbour_ids)

          neighbour_ids.reject { |neighbour| new_tiles.key?(neighbour) }.each do |neighbour_id|
            neighbour_neighbour_ids = identify_neighbour_ids(neighbour_id)
            new_tiles[neighbour_id] = identify_new_color(@tiles[neighbour_id], neighbour_neighbour_ids)
          end
        end
        @tiles = new_tiles
      end

      private

      def new_id(old_id, dir)
        old_id.zip(DIR_CHANGES[dir]).map(&:sum)
      end

      def flip(prev_val)
        (prev_val + 1) % 2
      end

      def identify_new_color(current_color, neighbour_ids)
        adj_sum = neighbour_ids.map { |neighbour| @tiles[neighbour] }.sum
        new_color = current_color

        if current_color == 1
          new_color = 0 if adj_sum.zero? || adj_sum > 2
        elsif adj_sum == 2
          new_color = 1
        end

        new_color
      end

      def identify_neighbour_ids(id)
        [id].product(DIR_CHANGES.values).map { |f, s| f.zip(s).map(&:sum) }
      end
    end

    class Puzzle24 < ::Aoc::PuzzleBase
      def initialize
        @floor = Floor.new
        @paths = []
        super()
      end

      def solve
        @paths.each { |path| @floor.follow_path(path) }
      end

      def handle_input_line(line, *_args)
        @paths << line
      end
    end
  end
end
