module Aoc2021
  module Day14
    class Puzzle14 < ::Aoc::PuzzleBase
      def initialize
        @rules = {}
      end

      def solve
        raise 'Not defined'
      end

      def alternative_count_polymer_difference(template, steps)
        @starting = template.chars.first
        template_occurs = Hash.new(0)

        template.chars.each_cons(2).each { |pair| template_occurs[pair.join] += 1 }
        steps.times { |i| template_occurs = alternative_step(template_occurs)}

        count_occurs(template_occurs).minmax_by { |_char, occ| occ }.map(&:last).reduce(&:-).abs
      end

      def count_occurs(template_occurs)
        res = template_occurs.map { |k, v| [k.last, v] }.group_by(&:first).transform_values { |v| v.sum(&:last) }
        res[@starting] += 1
        res
      end

      def alternative_step(template_occurs)
        res = Hash.new(0)
        template_occurs.each do |key, val|
          res[key.first + @rules[key]] += val
          res[@rules[key] + key.last] += val
        end
        res
      end

      def count_polymer_difference(template, steps)
        steps.times { template = step(template)}

        template.chars.tally.values.minmax.reduce(&:-).abs
      end

      def step(template)
        res = ''
        template.chars.each_cons(2) do |pattern|
          res += pattern.first + @rules[pattern.join]
        end
        res += template.chars.last
        res
      end

      def handle_input_line(line, *_args)
        return if line.empty?

        if line.include? '->'
          k, v = line.split(' -> ')
          @rules[k] = v
        else
          @template = line
        end
      end

      def unit_tests
      end
    end
  end
end
