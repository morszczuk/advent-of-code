module Aoc2022
  module Day2
    class Puzzle2B < Puzzle2
      def solve
        @strategy.map do |opp, result|
          me = correct_shape(result, opp)
          result_scoe(result(opp, me)) + VAL[me]
        end.sum
      end

      def correct_shape(result, opp)
        case opp
        when 'A' # rock
          case result
          when 'X' then 'Z'
          when 'Y' then 'X'
          when 'Z' then 'Y'
          end
        when 'B'
          case result
          when 'X' then 'X'
          when 'Y' then 'Y'
          when 'Z' then 'Z'
          end
        when 'C'
          case result
          when 'X' then 'Y'
          when 'Y' then 'Z'
          when 'Z' then 'X'
          end
        end
      end
    end
  end
end

