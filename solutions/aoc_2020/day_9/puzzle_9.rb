module Aoc2020
  module Day9
    class FirstNotWorkingElementAfterPreambleFinder
      attr_accessor :data, :preamble_size

      def initialize(data, preamble_size: 5)
        @data = data
        @preamble_size = preamble_size
        @current_step = 0
        @result = nil
      end

      def call
        next_element until breaks_preamble_rule?

        @data[@current_step + @preamble_size]
      end

      def next_element
        @current_step += 1
      end

      def breaks_preamble_rule?
        current_value = @data[@current_step + @preamble_size]

        @data[0 + @current_step, @preamble_size].combination(2).none? { |elems| elems.sum == current_value }
      end
    end

    class ContingenceFinder
      def initialize(data, target_number)
        @data = data
        @target_number = target_number
        @con_size = 2
      end

      def call
        process_next_con until target_found?

        result
      end

      def process_next_con
        @con_size += 1
      end

      def target_found?
        (@cons_which_sums_to_target = @data.each_cons(@con_size).detect(&method(:sums_to_target?))).present?
      end

      def sums_to_target?(elems)
        elems.sum == @target_number
      end

      def result
        result = @cons_which_sums_to_target.sort

        result.first + result.last
      end
    end

    class Input
      attr_accessor :data

      def initialize
        @data = []
      end

      def add_number(raw_number)
        @data << raw_number.to_i
      end
    end

    class Puzzle9 < ::Aoc::PuzzleBase
      def initialize
        @input = Input.new
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line)
        @input.add_number(line)
      end

      def unit_tests
      end
    end
  end
end
