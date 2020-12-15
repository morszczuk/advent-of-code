module Aoc2020
  module Day15
    class MemoryGame
      attr_reader :turns

      def initialize(starting_numbers)
        @starting_numbers = starting_numbers
        @current_turn = starting_numbers.size
        @said_numbers = initiate_with(starting_numbers)
        @last_spoken = starting_numbers.last
      end

      def play_for(rounds:)
        (rounds - @starting_numbers.size).times { take_turn }

        @last_spoken
      end

      def take_turn
        last_time_spoken = @said_numbers[@last_spoken][-2]
        this_turn_number = last_time_spoken.present? ? @current_turn - last_time_spoken : 0
        @said_numbers[this_turn_number] += [@current_turn + 1]
        @last_spoken = this_turn_number
        @current_turn += 1

        @said_numbers[@last_spoken].delete_at(-3)
      end

      private

      def initiate_with(starting_numbers)
        said_numbers = Hash.new([])
        starting_numbers.each_with_index.map { |number, index| said_numbers[number] = [index + 1] }

        said_numbers
      end
    end

    class Puzzle15 < ::Aoc::PuzzleBase
      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @starting_numbers = line.split(',').map(&:to_i)
      end
    end
  end
end
