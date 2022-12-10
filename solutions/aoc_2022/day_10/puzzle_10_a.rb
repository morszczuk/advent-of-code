module Aoc2022
  module Day10
    class Puzzle10A < Puzzle10
      def solve
        results = prepare_ticks(@cmds)
        result_cycles = [18, 58, 98, 138, 178, 218]

        result_cycles.reduce(0) do |result, cycle_id|
          result += results[cycle_id][1] * (cycle_id + 2)
        end
      end
    end
  end
end

