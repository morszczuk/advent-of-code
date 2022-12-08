module Aoc2022
  module Day7
    class Puzzle7B < Puzzle7
      def solve
        start_node = build_graph(@cmds)
        start_node.calculate_size
        nodes = start_node.all_children
        sizes = nodes.map { |node| node.size }

        total = 70000000
        free  = 30000000

        sum = start_node.size

        sizes.select { |s| (sum - s) < (total - free)}.min
      end
    end
  end
end

