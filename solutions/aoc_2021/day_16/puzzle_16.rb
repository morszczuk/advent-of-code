module Aoc2021
  module Day16
    class Puzzle16 < ::Aoc::PuzzleBase
      def initialize
        @lines_to_process = []
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        # hex_line = line
        # pp hex_line
        # byebug
        @line_to_process = line.chars.map { |n| n.to_i(16).to_s(2).rjust(4, '0') }.join('')
        @lines_to_process << @line_to_process
        pp line.chars.map { |n| [n, n.to_i(16).to_s(2).rjust(4, '0')] }.to_h
      end

      def unit_tests
      end
    end
  end
end
