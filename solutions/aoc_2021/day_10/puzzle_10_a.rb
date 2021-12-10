module Aoc2021
  module Day10
    class Puzzle10A < Puzzle10
      def solve
        invalid_entries = @entries.map(&:validate).reject { |e| [:valid, :incomplete].include? e[:status]}

        invalid_entries.sum { |e| INCORRECT_CLOSING_SCORE[e[:data]] }
      end
    end
  end
end

