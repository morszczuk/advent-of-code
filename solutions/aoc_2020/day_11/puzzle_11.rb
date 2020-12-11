module Aoc2020
  module Day11
    class FloorLayout
      FLOOR = '.'.freeze
      OCCUPIED = '#'.freeze
      EMPTY = 'L'.freeze

      attr_accessor :places

      def initialize(places = [])
        @places = places
        @closest_seats = {}
      end

      def add_line(new_places)
        @places << new_places
      end

      def count_occupied
        @places.map do |row|
          row.count { |place| place == OCCUPIED }
        end.flatten.sum
      end

      def place(i, j)
        @places[i][j]
      end

      def set(i, j, new_value)
        @places[i][j] = new_value
      end

      def closest_seat_in_all_directions(place_i, place_j)
        ranges = [
          [(place_i..place_i).to_a, (0..place_j).to_a.reverse], # left
          [(place_i..place_i), (place_j..(@places.first.size - 1))], # right
          [(0..place_i).to_a.reverse, (place_j..place_j)], # top
          [(place_i..(@places.size - 1)), (place_j..place_j)] # bottom
        ]

        line_results = ranges.map do |range|
          closes_seat(place_i, place_j, range[0], range[1])
        end.flatten.compact

        decrement = ->(coord) { coord - 1 }
        increment = ->(coord) { coord + 1 }

        diagonal_results = [
          diagonal(place_i, place_j, decrement, decrement), # top left
          diagonal(place_i, place_j, decrement, increment), # top right
          diagonal(place_i, place_j, increment, decrement), # bottom left
          diagonal(place_i, place_j, increment, increment)  # bottom right
        ].flatten.compact

        line_results + diagonal_results
      end

      def diagonal(place_i, place_j, movement_i, movement_j)
        current_i = place_i
        current_j = place_j

        while (current_i >= 0 && current_i < @places.size) && (current_j >= 0 && current_j < @places.first.size)
          return @places[current_i][current_j] if (place_i != current_i || place_j != current_j) && @places[current_i][current_j] != FLOOR

          current_i = movement_i.call(current_i)
          current_j = movement_j.call(current_j)
        end

        nil
      end

      def closes_seat(place_i, place_j, i_range, j_range)
        i_range.each do |i|
          j_range.each do |j|
            return @places[i][j] if ((place_i != i || place_j != j) && @places[i][j] != FLOOR)
          end
        end

        nil
      end

      def adjacent_to(place_i, place_j)
        top_i = (place_i - 1).negative? ? 0 : place_i - 1
        left_j = (place_j - 1).negative? ? 0 : place_j - 1
        bottom_i = (place_i + 1) >= places.size ? (places.size - 1) : place_i + 1
        right_j = (place_j + 1) >= places.first.size ? (places.first.size - 1) : place_j + 1

        (top_i..bottom_i).map do |i|
          (left_j..right_j).map do |j|
            next if place_i == i && place_j == j

            @places[i][j]
          end
        end.flatten.compact
      end
    end

    class HumanFloorAssigner
      def initialize(floor_layout, seat_mover)
        @previous_floor_layout = floor_layout
        @current_floor_layout = floor_layout
        @seat_mover = seat_mover
      end

      def call
        loop do
          move_seats
          break if no_change?
        end

        @current_floor_layout.count_occupied
      end

      def move_seats
        @previous_floor_layout = @current_floor_layout
        @current_floor_layout = @seat_mover .new(@previous_floor_layout).call
      end

      def no_change?
        @previous_floor_layout.places == @current_floor_layout.places
      end
    end

    class AdjacentRuleSeatMover
      def initialize(floor_layout)
        @floor_layout = floor_layout
        @floor_layout_after_move = FloorLayout.new(floor_layout.places.deep_dup)
      end

      def call
        @floor_layout.places.each_with_index do |row, i|
          row.each_with_index do |_place, j|
            @floor_layout_after_move.set(i, j, determine_new_value(i, j))
          end
        end

        @floor_layout_after_move
      end

      def determine_new_value(i, j)
        adjacent_seats = @floor_layout.adjacent_to(i, j).reject { |place| place == FloorLayout::FLOOR }
        adjacent_taken_seats_count = adjacent_seats.count { |place| place == FloorLayout::OCCUPIED }

        case @floor_layout.place(i, j)
        when FloorLayout::EMPTY
          return FloorLayout::OCCUPIED if adjacent_taken_seats_count.zero?
        when FloorLayout::OCCUPIED
          return FloorLayout::EMPTY if adjacent_taken_seats_count >= 4
        end

        @floor_layout.place(i, j)
      end
    end

    class ClosestSeatMover < AdjacentRuleSeatMover
      def determine_new_value(i, j)
        adjacent_seats = @floor_layout.closest_seat_in_all_directions(i, j)

        adjacent_taken_seats_count = adjacent_seats.count { |place| place == FloorLayout::OCCUPIED }

        case @floor_layout.place(i, j)
        when FloorLayout::EMPTY
          return FloorLayout::OCCUPIED if adjacent_taken_seats_count.zero?
        when FloorLayout::OCCUPIED
          return FloorLayout::EMPTY if adjacent_taken_seats_count >= 5
        end

        @floor_layout.place(i, j)
      end
    end

    class Puzzle11 < ::Aoc::PuzzleBase
      def initialize
        @floor_layout = FloorLayout.new
        super()
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line)
        @floor_layout.add_line(line.split(''))
      end

      def unit_tests
        arr_1 = [['.', 'L'], ['L', 'L']]

        assert_equal  ['L', 'L', 'L' ], FloorLayout.new(arr_1).adjacent_to(0, 0)
      end
    end
  end
end
