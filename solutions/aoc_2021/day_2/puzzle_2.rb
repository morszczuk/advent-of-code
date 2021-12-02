module Aoc2021
  module Day2
    class Submarine
      attr_reader :depth, :position

      def initialize
        @depth = 0
        @position = 0
      end

      def do_command(command, value)
        method(command).call(value)
      end

      def forward(value)
        @position += value
      end

      def down(value)
        @depth += value
      end

      def up(value)
        @depth -= value
      end
    end

    class SubmarineWithAim < Submarine
      attr_reader :aim

      def initialize
        super
        @aim = 0
      end

      def forward(value)
        @position += value
        @depth -= @aim * value
      end

      def down(value)
        @aim -= value
      end

      def up(value)
        @aim += value
      end
    end

    class Puzzle2 < ::Aoc::PuzzleBase
      def initialize
        @commands = []
        super
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        command, value = line.split(' ')
        value = value.to_i
        @commands << [command, value]
      end

      def unit_tests
      end
    end
  end
end
