module Aoc2021
  module Day3
    class Puzzle3A < Puzzle3
      def solve
        gamma_rate_sets = {}
        epsilon_rate_sets = {}

        @numbers.each do |number|
          gamma_rate_sets = set_rate(number.chars, gamma_rate_sets)
          epsilon_rate_sets = set_rate(number.chars.reverse, epsilon_rate_sets)
        end

        gamma_rate = rate_value(gamma_rate_sets).to_i(2)
        epsilon_rate = epsilon_rate_value(gamma_rate_sets).to_i(2)

        pp "Gamma"
        pp gamma_rate
        pp "Epsilon"
        pp epsilon_rate

        gamma_rate * epsilon_rate
      end

      def rate_value(rate_sets)
        rate_sets.values.map do |value|
          value.to_a.max { |a, b| a.last <=> b.last }.first
        end.join('')
      end

      def epsilon_rate_value(rate_sets)
        rate_sets.values.map do |value|
          value.to_a.min { |a, b| a.last <=> b.last }.first
        end.join('')
      end

    end
  end
end

