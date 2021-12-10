module Aoc2021
  module Day6
    class Puzzle6 < ::Aoc::PuzzleBase
      def initialize
        @saved_values = {}
      end

      def solve
        raise 'Not defined'
      end

      def sum_of_amount_of_fishes(days)
        @fishes.sum { |starting_fish| amount_of_fishes(starting_fish, days, 0) }
      end

      def amount_of_fishes(starting_value, number_of_days, starting_day)
        return @saved_values[[starting_value, number_of_days, starting_day]] if @saved_values[[starting_value, number_of_days, starting_day]].present?

        days_of_recreation = number_of_days - starting_day - starting_value
        first_counts = number_of_days < (starting_value + starting_day) ? 0 : 1
        number_of_new_fishes = (days_of_recreation) / 7 + first_counts

        @saved_values[[starting_value, number_of_days, starting_day]] = 1 + number_of_new_fishes.times.sum do |i|
          new_starting_day = (starting_value + starting_day) + (7*(i)) + 1
          new_starting_day > number_of_days ? 0 : amount_of_fishes(8, number_of_days, new_starting_day)
        end
      end

      def handle_input_line(line, *_args)
        @fishes = line.split(',').map(&:to_i)
      end

      def unit_tests
      end
    end
  end
end
