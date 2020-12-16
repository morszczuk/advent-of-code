module Aoc2020
  module Day16
    class Puzzle16B < Puzzle16
      def solve
        departure_rules = find_departure_rules

        departure_rules.map(&:last).map { |i| @my_ticket.values[i] }.reduce(:*)
      end

      def find_departure_rules
        @valid_tickets = @nearby_tickets.select { |t| t.valid?(@rules) }
        valid_rules_for_tickets = @valid_tickets.map { |t|  t.possible_rules_order(@rules) }.transpose

        valid_rules_for_tickets = valid_rules_for_tickets.map do |field|
          field.reduce(&:intersection)
        end

        loop do
          valid_rules_for_tickets = clear_duplicates(valid_rules_for_tickets)
          break if valid_rules_for_tickets.all?(&:one?)
        end

        field_name = /(departure)/
        valid_rules_for_tickets.each_with_index.map { |rule, index| [field_name.match?(rule.first.field), index.dup] }.select { |e| e.first == true }
      end

      def clear_duplicates(arr)
        fixed = arr.select(&:one?).flatten

        arr.map do |c|
          c.one? && fixed.include?(c.first) ? c : c - fixed
        end
      end
    end
  end
end
