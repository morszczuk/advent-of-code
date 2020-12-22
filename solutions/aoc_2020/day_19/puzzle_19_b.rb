module Aoc2020
  module Day19
    class Puzzle19B < Puzzle19
      def solve
        regex = RegexBuilder.new(@rules, @terminals, multiple: true).call

        @messages.sum { |m| regex.match?(m) ? 1 : 0 }
      end
    end
  end
end

