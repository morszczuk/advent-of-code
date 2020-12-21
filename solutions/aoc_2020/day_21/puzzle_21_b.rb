module Aoc2020
  module Day21
    class Puzzle21B < Puzzle21
      def solve
        allergens_list = super
        result = {}

        loop do
          one_to_one = allergens_list.select { |a, ing| ing.one? }
          discovered = one_to_one.values.flatten

          result.merge! one_to_one
          allergens_list.except!(*one_to_one.keys).transform_values! { |ingredients| ingredients - discovered }

          break if allergens_list.empty?
        end

        result.to_a.sort_by(&:first).map(&:second).flatten.join(',')
      end
    end
  end
end

