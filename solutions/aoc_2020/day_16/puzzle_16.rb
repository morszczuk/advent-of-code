module Aoc2020
  module Day16
    class Ticket
      attr_reader :values

      def initialize(values)
        @values = values
      end

      def self.parse(line)
        new(line.split(',').map!(&:to_i))
      end

      def validate(rules)
        @values.map do |value|
          rules.any? { |rule| rule.valid? value } ? 0 : value
        end.flatten.sum
      end

      def valid?(rules)
        validation = @values.map do |value|
          rules.any? { |rule| rule.valid?(value) }
        end

        validation.all? { |v| v == true }
      end

      def possible_rules_order(rules)
        @values.map do |value|
          rules.select { |rule| rule.valid? value }
        end
      end
    end

    class Rule
      attr_reader :field, :range_1, :range_2

      def initialize(field, range_1, range_2)
        @field = field
        @range_1 = range_1
        @range_2 = range_2
      end

      def self.parse(line)
        field, ranges = line.split(': ')

        range_1, range_2 = ranges.split(' or ')
        range_1 = range_1.split('-').map!(&:to_i)
        range_2 = range_2.split('-').map!(&:to_i)


        new(field, (range_1[0]..range_1[1]), (range_2[0]..range_2[1]))
      end

      def valid?(value)
        range_1.member?(value) || range_2.member?(value)
      end
    end

    class Puzzle16 < ::Aoc::PuzzleBase
      def initialize
        @line_type = :rule
        @nearby_tickets = []
        @validations = []
        @rules = []
        super()
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        return if line.empty?

        case line
        when /your ticket/
          @line_type = :ticket
          return
        when /nearby tickets/
          @line_type = :nearby_tickets
          return
        end

        case @line_type
        when :rule then @rules << Rule.parse(line)
        when :ticket then @my_ticket = Ticket.parse(line)
        when :nearby_tickets then @nearby_tickets << Ticket.parse(line)
        end
      end

      def unit_tests
        rule = Rule.parse('type: 41-438 or 453-959')
        assert_equal 'type', rule.field
        assert_equal (41..438), rule.range_1
        assert_equal (453..959), rule.range_2

        ticket = Ticket.parse '40,4,50'
        assert_equal [40, 4, 50], ticket.values

        ticket = Ticket.new([4])
        rule = Rule.new('field', (2..4), (8..10))

        assert_equal 0, ticket.validate([rule])

        rule = Rule.new('field', (1..2), (8..10))
        assert_equal 4, ticket.validate([rule])
      end
    end
  end
end
