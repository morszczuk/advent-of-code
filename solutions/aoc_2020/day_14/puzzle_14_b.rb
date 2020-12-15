module Aoc2020
  module Day14
    class Puzzle14B < Puzzle14
      def initialize
        @mask_class = BinaryMask
        @memory = MemoryWithMemIdMasked.new
        super()
      end

      def solve
        @memory.memory_entries.values.sum
      end
    end
  end
end

