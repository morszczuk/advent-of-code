module Aoc2020
  module Day23
    class Puzzle23B < Puzzle23
      def solve
        max_elem = @cups.max

        ((max_elem + 1)..1_000_000).each do |i|
          @cups_list.append(i)
        end

        rounds = 10_000_000
        result_list = CrabsCupListGame.new(@cups_list).play(rounds)
        starting_node = result_list.find(1)

        starting_node.next.value * starting_node.next.next.value
      end
    end
  end
end

