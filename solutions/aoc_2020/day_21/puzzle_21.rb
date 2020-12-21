module Aoc2020
  module Day21
    class Puzzle21 < ::Aoc::PuzzleBase
      def initialize
        @possible_allergens = Hash.new { [] }
        @ingredients_list = []
        super()
      end

      def solve
        @possible_allergens.transform_values! do |ingredients|
          ingredients.reduce(:&)
        end
      end

      def handle_input_line(line, *_args)
        ingredients, allergens = line.split(' (contains ')
        ingredients = ingredients.split(' ')
        allergens = allergens.tr(')', '').split(', ')

        @ingredients_list << ingredients

        allergens.each do |allergen|
          @possible_allergens[allergen] += [ingredients]
        end
      end
    end
  end
end
