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
        dups = {}
        template_occurs = Hash.new(0)

        template.chars.each_cons(2).each { |pair| template_occurs[pair.join] += 1 }
        steps.times { |i| template_occurs, dups = alternative_step(template_occurs)}

        counts = count_occurs(template_occurs, dups).values
        counts.max - counts.min
      end

      def count_occurs(template_occurs, dups)
        counts = Hash.new(0)
        template_occurs.each do |sub, occ|
          sub.chars.each do |s|
            counts[s] += occ
          end
        end
        dups[@starting] -= 1
        dups.each { |k, v| counts[k] -= v }
        counts
      end

      def alternative_step(template_occurs)
        res = Hash.new(0)
        dups = Hash.new(0)
        template_occurs.each do |key, val|
          res[key.first + @rules[key]] += val
          res[@rules[key] + key.last] += val
          dups[key.first] += val
          dups[@rules[key]] += val
        end
        [res, dups]
      end

      def count_polymer_difference(template, steps)
        template = template
        steps.times { template = step(template)}
        counts = template.chars.tally.values
        counts.max - counts.min
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
