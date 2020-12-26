module Aoc2020
  module Day20
    class Tile
      attr_accessor :tile_number, :elements, :option

      def initialize(tile_number, elements = [])
        @elements = elements
        @tile_number = tile_number
        @option = [0, 0] # flipped, rotated
        @option_images = {}
      end

      def add_line(line)
        @elements << line
      end

      def option_image
        @option_images[@option] ||= build_option_image
      end

      def build_option_image
        all_elements = @elements.map(&:chars)
        if option.first > 0
          (4 - option.first).times do
            all_elements = all_elements.transpose.map(&:reverse)
          end
        end

        if option.second == 1
          all_elements.map!(&:reverse)
        end

        all_elements
      end

      def possible_dimensions(part)
        # options = [[0, 0], [0, 1], [1, 0], [1, 1]]
        options = [0, 1, 2, 3].product [0, 1]

        options.map { |option| { dimension(part, option) => option } }.reduce(&:merge)
      end

      def dimension(part, dimension_option = nil)
        dimension_option ||= @option
        get_dimensions(dimension_option)[part]
      end

      def get_dimensions(dimension_option)
        all_possible_dimensions[dimension_option[0]][dimension_option[1]]
      end

      def all_possible_dimensions
        @all_possible_dimensions ||= [
          [default_dimensions, flipped_dimensions(default_dimensions)],
          [rotated_1, flipped_dimensions(rotated_1)],
          [rotated_2, flipped_dimensions(rotated_2)],
          [rotated_3, flipped_dimensions(rotated_3)]
        ]
      end

      def default_dimensions
        @default_dimensions ||= [
          normal_top_side,
          normal_right_side,
          normal_bottom_side,
          normal_left_side
        ]
      end

      def rotated_1
        @rotated_1 ||= [
          normal_right_side,
          flip(normal_bottom_side),
          normal_left_side,
          flip(normal_top_side),
        ]
      end

      def rotated_2
        @rotated_2 ||= [
          flip(normal_bottom_side),
          flip(normal_left_side),
          flip(normal_top_side),
          flip(normal_right_side),
        ]
      end

      def rotated_3
        @rotated_3 ||= [
          flip(normal_left_side),
          normal_top_side,
          flip(normal_right_side),
          normal_bottom_side,
        ]
      end

      def rotated_dimensions
        @rotated_dimensions ||= [
          normal_bottom_side,
          normal_left_side,
          normal_top_side,
          normal_right_side
        ].map(&method(:flip))
      end

      def flipped_dimensions(dimensions)
        [
          flip(dimensions[0]),
          dimensions[3],
          flip(dimensions[2]),
          dimensions[1]
        ]
      end

      def flip(dimension)
        dimension.chars.reverse.join('')
      end

      def normal_right_side
        @normal_right_side ||= @elements.map { |e| e.chars.last }.join('')
      end

      def normal_left_side
        @normal_left_side ||= @elements.map { |e| e[0] }.join('')
      end

      def normal_top_side
        @elements[0]
      end

      def normal_bottom_side
        @elements.last
      end
    end

    class PictureAlgorithm
      def initialize(tiles)
        @tiles = tiles
        @size = tiles.size
        @one_size = Math.sqrt(@size).to_i
      end

      def call
        solution = {}

        @tiles.each do |tile|
          algorithm_step(tile, 0, 0, solution)
        end

        [@final_result, @image_solution]
      end

      def algorithm_step(element, x, y, current_solution)
        possible_left_options = element.possible_dimensions(3)
        possible_top_options = element.possible_dimensions(0)

        elem_top = current_solution[[x - 1, y]]
        elem_left = current_solution[[x, y - 1]]

        possible_left_options = possible_left_options.select { |dimension, _option | dimension == elem_left.dimension(1) } unless elem_left.nil?
        possible_top_options = possible_top_options.select { |dimension, _option | dimension == elem_top.dimension(2) } unless elem_top.nil

        return if possible_left_options.empty? || possible_top_options.empty?

        next_x = (y == @one_size - 1) ? x + 1 : x
        next_y = (y == @one_size - 1) ? 0 : y + 1

        possible_options = possible_left_options.values & possible_top_options.values
        possible_options.each do |elem_option|
          elem = element.dup
          elem.option = elem_option
          added_solution = current_solution.dup
          added_solution[[x, y]] = elem

          if (current_solution.values.size == @size - 1) && possible_options.present?
            unless @final_result.present?
              @final_result = current_solution[[0, 0]].tile_number * current_solution[[@one_size - 1, 0]].tile_number * current_solution[[0, @one_size - 1]].tile_number * elem.tile_number
              @image_solution = added_solution
            end
          end

          tiles_used = added_solution.values.map(&:tile_number)
          tiles_to_pick = @tiles.reject { |t| tiles_used.include?(t.tile_number) }

          tiles_to_pick.each do |next_tile|
            algorithm_step(next_tile, next_x, next_y, added_solution)
          end
        end
      end
    end

    class SeaImage
      attr_accessor :image

      def initialize
        @image = {}
        @current_row = 0
        @dragon_fields = []
        @dragon_values = []
        @dragons_count = 0

        @image_as_arr = []
      end

      def add_line(line)
        line.chars.each_with_index { |l, i| @image[[@current_row, i]] = l }
        @current_row += 1
        @image_as_arr << line.chars
      end

      def arr_to_hash(arr_source)
        result = {}
        arr_source.each_with_index do |row, row_id|
          row.each_with_index { |l, i| result[[row_id, i]] = l }
        end
        result
      end

      def count_dragons
        dragons_counts = (0..3).map do |option_x|
          (0..1).map do |option_rotation|
            pp "Option [#{option_x}, #{option_rotation}]"
            option_image = build_option_image([option_x, option_rotation], @image_as_arr)
            [[option_x, option_rotation], count_dragons_in_shape(arr_to_hash(option_image))]
          end
        end

        option, count = dragons_counts.flatten(1).select { |_fas, count| count > 0 }.first
        option_image = build_option_image(option, @image_as_arr)

        total = option_image.flatten.map { |e| e == '#' ? 1 : 0 }.sum
        dragon_dots = @dragon_values.map { |e| e == '#' ? 1 : 0 }.sum

        total - dragon_dots
      end

      def build_option_image(option, source)
        # all_elements = @elements.map(&:chars)
        # byebug
        result = source.deep_dup
        if option.first > 0
          (4 - option.first).times do
            result = result.transpose.map(&:reverse)
          end
        end

        if option.second == 1
          result.map!(&:reverse)
        end

        result
      end

      def count_dragons_in_shape(image_source)
        image_source.select { |_key, val| val == '#' }.each do |key, val|
          if dragon_shape?(key, image_source)
            @dragons_count += 1
            @dragon_fields += dragon_keys(key)
            @dragon_values += dragon_keys(key).map { |key_key| image_source[key_key] }
          end
        end
        @dragons_count
      end

      def dragon_shape?(key, image_source)
        dragon_keys = dragon_keys(key)

        dragon_keys.all? do |single_key|
          image_source[single_key] == '#'
        end
      end

      def dragon_keys(key)
        byebug if key[0] == nil || key[1] == nil
        [[0,0],[0,5], [0,6], [0,11], [0,12], [0,17], [0,18], [0,19], [-1, 18], [1, 1], [1, 4], [1, 7], [1, 10], [1, 13], [1, 16]].map do |part_key|
          [key[0] + part_key[0], key[1] + part_key[1]]
        end
      end
    end

    class Puzzle20 < ::Aoc::PuzzleBase
      def initialize
        @tiles = []
        super()
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        if @part_b
          @sea_image.add_line(line)
        else
          return if line.empty?

          if line.include?('Tile')
            @tiles << Tile.new(line.tr('Tile :', '').to_i)
          else
            @tiles.last.add_line(line)
          end
        end
      end

      def unit_tests
        tile = Tile.new(43, ['ab', 'cd'])
        # tile.option = [1, 0]
        tile.option = [0, 1]
        assert_equal 'ba', tile.dimension(0)
        assert_equal 'ac', tile.dimension(1)
        assert_equal 'dc', tile.dimension(2)
        assert_equal 'bd', tile.dimension(3)

        tile.option = [2, 1]
        assert_equal 'cd', tile.dimension(0)
        assert_equal 'db', tile.dimension(1)
        assert_equal 'ab', tile.dimension(2)
        assert_equal 'ca', tile.dimension(3)

        # tile.option = [0, 1]
        tile.option = [2, 0]
        assert_equal 'dc', tile.dimension(0)
        assert_equal 'ca', tile.dimension(1)
        assert_equal 'ba', tile.dimension(2)
        assert_equal 'db', tile.dimension(3)
      end
    end
  end
end
