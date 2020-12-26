module Aoc2020
  module Day20
    class Puzzle20B < Puzzle20
      def initialize
        @part_b = true
        @sea_image = SeaImage.new
        super()
      end

      def solve
        @sea_image.count_dragons
      end
    end
  end
end

