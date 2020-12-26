module Aoc2020
  module Day13
    class Puzzle13A < Puzzle13
      def solve
        @buses = @buses.map(&:first)
        @depart_time = @starting_time.dup

        loop do
          break if (@chosen_bus = check_buses).present?

          @depart_time += 1
        end

        @chosen_bus * (@depart_time - @starting_time)
      end

      def check_buses
        @buses.detect { |bus| (@depart_time % bus).zero? }
      end
    end
  end
end
