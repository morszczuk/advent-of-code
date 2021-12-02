module Aoc2021
  module Day2
    class Puzzle2B < Puzzle2
      def solve
        submarine = SubmarineWithAim.new
        @commands.each { |params| submarine.do_command(*params) }
        submarine.depth * submarine.position
      end
    end
  end
end

