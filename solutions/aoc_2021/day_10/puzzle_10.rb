module Aoc2021
  module Day10
    class Entry
      MAPPING = {
        '{' => '}',
        '[' => ']',
        '(' => ')',
        '<' => '>'
      }

      attr_reader :elems
      def initialize(elems)
        @elems = elems
      end

      def validate
        validation_stack = []
        @elems.each do |elem|
          if MAPPING.key? elem
            validation_stack << elem
          else
            return ({ status: :corrupted, data: elem }) if MAPPING[validation_stack.pop] != elem
          end
        end

        validation_stack.empty? ? ({ status: :valid }) : ({ status: :incomplete, data: missing_closings(validation_stack) })
      end

      def missing_closings(validation_stack)
        validation_stack.reverse.map { |e| MAPPING[e] }
      end
    end

    class Puzzle10 < ::Aoc::PuzzleBase
      INCORRECT_CLOSING_SCORE = {
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137
      }

      COMPLETION_SCORE = {
        ')' => 1,
        ']' => 2,
        '}' => 3,
        '>' => 4
      }

      def initialize
        @entries = []
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @entries << Entry.new(line.chars)
      end

      def unit_tests
      end
    end
  end
end
