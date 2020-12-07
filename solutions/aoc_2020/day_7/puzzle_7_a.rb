module Aoc2020
  module Day7
    class Puzzle7A < Puzzle7
      def solve
        ParentNodesCounter.new(@graph, :shiny_gold).call.size
      end
    end
  end
end

