module Aoc2022
  module Day11
    class Monkey
      attr_accessor :items , :operation , :divide_test , :true_test , :false_test, :inspections

      def initialize
        @items = []
        @operation = nil
        @divide_test = nil
        @true_test = nil
        @false_test = nil
        @inspections = 0
      end

      def round(stress_reducer:)
        passes = []
        until @items.empty?
          item = @items.shift
          new_worry = @operation.call(item)
          new_worry = stress_reducer.call(new_worry)
          if new_worry % @divide_test == 0
            passes << [@true_test, new_worry]
          else
            passes << [@false_test, new_worry]
          end
          @inspections += 1
        end

        passes
      end
    end

    class Puzzle11 < ::Aoc::PuzzleBase
      def initialize
        @monkeys = [Monkey.new]
      end

      def solve
        raise 'Not defined'
      end

      def monkey_business(rounds, &stress_reducer)
        rounds.times do |i|
          @monkeys.size.times do |m_id|
            @monkeys[m_id].round(stress_reducer: stress_reducer).each do |new_m_id, elem|
              @monkeys[new_m_id].items << elem
            end
          end
        end

        @monkeys.map(&:inspections).sort.last(2).reduce(:*)
      end

      def handle_input_line(line, *_args)
        if line.empty?
          @monkeys << Monkey.new
        else
          case line
          when /Starting items/
            @monkeys.last.items = line.gsub('Starting items: ', '').split(', ').map(&:to_i)
          when /Operation:/
            @monkeys.last.operation = eval "lambda { |old| #{line.gsub('Operation: ', '')}}"
          when /Test:/
            @monkeys.last.divide_test = /(\d+)/.match(line)[0].to_i
          when /If true/
            @monkeys.last.true_test = /(\d+)/.match(line)[0].to_i
          when /If false/
            @monkeys.last.false_test = /(\d+)/.match(line)[0].to_i
          end
        end
      end

      def unit_tests
      end
    end
  end
end
