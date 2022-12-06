module Aoc2022
  module Day6
    class Puzzle6 < ::Aoc::PuzzleBase
      def initialize
      end

      def solve
        raise 'Not defined'
      end

      def packet_marker(packet_size)
        @buffer.each_cons(packet_size).each_with_index.find do |tuple, index|
          tuple.uniq.size == packet_size
        end.last + packet_size
      end

      def handle_input_line(line, *_args)
        @buffer = line.chars
      end

      def unit_tests
      end
    end
  end
end
