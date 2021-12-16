module Aoc2021
  module Day16
    class Puzzle16B < Puzzle16
      def solve
        result = super.first

        result[:decoded_message]
      end
    end
  end
end

