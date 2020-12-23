module Aoc2020
  module Day23
    class Puzzle23A < Puzzle23
      def solve
        result_list = CrabsCupListGame.new(@cups_list).play(@rounds)
        starting_node = result_list.find(1)

        res = ''
        node = starting_node.next
        while node != starting_node
          res += node.value.to_s
          node = node.next
        end

        res
      end
    end
  end
end

