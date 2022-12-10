module Aoc2022
  module Day2
    class Puzzle2 < ::Aoc::PuzzleBase
      VAL = {
        'X' => 1,
        'Y' => 2,
        'Z' => 3
      }

      def initialize
        @strategy = []
      end

      def solve
        raise 'Not defined'
      end

      def result_scoe(result)
        case result
        when :lost then 0
        when :draw then 3
        when :won then 6
        end
      end

      def result(opp, me)
        case opp
        when 'A' # rock
          case me
          when 'X' then :draw
          when 'Y' then :won
          when 'Z' then :lost
          end
        when 'B'
          case me
          when 'X' then :lost
          when 'Y' then :draw
          when 'Z' then :won
          end
        when 'C'
          case me
          when 'X' then :won
          when 'Y' then :lost
          when 'Z' then :draw
          end
        end
      end

      def handle_input_line(line, *_args)
        @strategy << line.split(' ')
      end

      def unit_tests
      end
    end
  end
end
