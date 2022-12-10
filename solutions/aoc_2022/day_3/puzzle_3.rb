# require 'active_support'
require 'active_support/core_ext/array/grouping'

module Aoc2022
  module Day3
    class Puzzle3 < ::Aoc::PuzzleBase
      VALS = [*('a'..'z').to_a, *('A'..'Z').to_a]

      def initialize
        @elems = []
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @elems << line.chars
      end

      def priority_value(common)
        common.map { |e| VALS.index(e) + 1 }.sum
      end

      def unit_tests
      end
    end
  end
end
