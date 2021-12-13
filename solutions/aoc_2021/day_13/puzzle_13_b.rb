module Aoc2021
  module Day13
    class Puzzle13B < Puzzle13
      def solve
        password = @folds.reduce(@card) do |card, fold|
          fold(card, *fold)
        end
        print_card(password)
      end
    end
  end
end

