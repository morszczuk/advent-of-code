module Aoc2020
  module Day25
    class Puzzle25A < Puzzle25
      def solve
        size_2 = LoopSizeDeterminer.new.find_loop_size(@public_keys.second)

        EncryptionKeyGenerator.call(@public_keys.first, size_2)
      end
    end
  end
end
