module Aoc2020
  module Day14
    class Puzzle14A < Puzzle14
      def initialize
        @mask_class = Mask
        @memory = Memory.new
        super()
      end

      def solve
        @memory.memory_entries.values.sum
      end
    end
  end
end

