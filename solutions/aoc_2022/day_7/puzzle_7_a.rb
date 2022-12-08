module Aoc2022
  module Day7
    class Puzzle7A < Puzzle7
      def solve
        start_node = build_graph(@cmds)
        start_node.calculate_size
        nodes = start_node.all_children
        sizes = nodes.map { |node| node.size }
        sizes.select { |size| size <= 100000 }.sum
      end
    end
  end
end
