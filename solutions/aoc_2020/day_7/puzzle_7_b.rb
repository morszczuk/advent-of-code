module Aoc2020
  module Day7
    class Puzzle7B < Puzzle7
      def solve
        AllPathsCounter.new(graph, :shiny_gold).call
      end
    end
  end
end

