module Aoc2022
  module Day5
    class Puzzle5 < ::Aoc::PuzzleBase
      def initialize
        @raw_input = true
        @input_type = :stacks
        @stack_lines = []
        @procedures = []
      end

      def solve
        raise 'Not defined'
      end

      def last_packs(keep_order: false)
        result = cleaned_input
        @procedures.each do |procedure|
          result = appply(procedure, result, keep_order: keep_order)
        end
        result.values.map(&:last).join
      end

      def appply(procedure, result, keep_order:)
        how_many, from, to = procedure
        take = result[from].pop(how_many)

        if keep_order
          result[to] += take
        else
          result[to] += take.reverse
        end

        result
      end

      def handle_input_line(line, *_args)
        return (@input_type = :procedures) if line.blank?

        if @input_type == :stacks
          @stack_lines << line.rstrip
        else
          @procedures << clean_procedure(line.rstrip)
        end
      end

      def cleaned_input
        keys = @stack_lines.pop.split(' ').map!(&:strip).map!(&:to_i)
        clean = keys.map { |k| [k, []] }

        until @stack_lines.empty?
          line = @stack_lines.pop
          keys.size.times do |i|
            clean[i].last << line[i*4 + 1] if line[i*4 + 1].present?
          end
        end

        clean.to_h
      end

      def clean_procedure(raw_procedure)
        split = raw_procedure.split(' ')

        [split[1], split[3], split[5]].map(&:to_i)
      end

      def unit_tests
      end
    end
  end
end
