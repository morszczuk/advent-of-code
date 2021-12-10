module Aoc2021
  module Day10
    class Puzzle10B < Puzzle10
      def solve
        incomplete = @entries.map(&:validate).select { |e| e[:status] == :incomplete }
        scores = incomplete.map(&method(:completion_score)).sort

        scores[scores.size/2]
      end

      def completion_score(result)
        result[:data].reduce(0) { |score, e| (score * 5 + COMPLETION_SCORE[e]) }
      end
    end
  end
end

