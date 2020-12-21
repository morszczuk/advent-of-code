module Aoc2020
  module Day21
    class Puzzle21A < Puzzle21
      def solve
        allergen_with_possible_ingredients = super
        potential_alleergenics = allergen_with_possible_ingredients.values.flatten.uniq

        @ingredients_list.flatten.reject { |r| potential_alleergenics.include? r }.count
      end
    end
  end
end
