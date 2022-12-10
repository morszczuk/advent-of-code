module Aoc2022
  module Day10
    class Puzzle10 < ::Aoc::PuzzleBase
      def initialize
        @cmds = []
      end

      def solve
        raise 'Not defined'
      end

      def prepare_ticks(cmds)
        cmds = @cmds
        res = 0
        actions = []
        cycles = 0
        result = 1
        results = []

        until cmds.empty? && actions.empty?
          if actions.empty?
            case (cmd = cmds.shift).first
            when :noop then actions << cmd.last
            else
              actions << 0
              actions << cmd.last
            end
          end
          result += actions.shift
          cycles += 1
          results << [cycles, result]
        end
        results
      end

      def handle_input_line(line, *_args)
        @cmds << case line
                when /noop/ then [:noop, 0]
                else [:addx, line.split(' ').last.to_i]
                end
      end

      def unit_tests
      end
    end
  end
end
