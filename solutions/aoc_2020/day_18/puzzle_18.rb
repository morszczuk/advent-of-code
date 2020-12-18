module Aoc2020
  module Day18
    class ClassicMath
      ORDER_OF_OPERATORS = {
        '+' => 1,
        '*' => 2
      }

      attr_accessor :tokens

      def initialize(expression)
        @expression = expression
        @tokens = parse(expression)
        @current_operations = [nil]
        @operations = []
      end

      def call
        @tokens.each do |token|
          case token
          when /\d/
            if @current_operations.last.nil?
              @current_operations[@current_operations.size - 1] = token.to_i
            else
              @current_operations[@current_operations.size - 1] = @current_operations.last.send(@operations.pop, token.to_i)
            end
          when /\+|\*/
            @operations << token
          when '('
            @current_operations << nil
          when ')'
            last_value = @current_operations.pop
            if @current_operations.last.nil?
              @current_operations[@current_operations.size - 1] = last_value
            else
              @current_operations[@current_operations.size - 1] = @current_operations.last.send(@operations.pop, last_value)
            end
          end
        end

        @current_operations.first
      end

      def parse(expression)
        expression.tr(' ', '').chars
      end
    end

    class ExpressionEvaluator
      ORDER_OF_OPERATORS = {
        '+' => 1,
        '*' => 2
      }

      attr_accessor :tokens

      def initialize(raw_line)
        @raw_line = raw_line
        @tokens = parse(raw_line)

        @operations = []
        @expressions = [[]]
      end
    end

    class NewMath < ClassicMath
      ORDER_OF_OPERATORS = {
        '+' => 1,
        '*' => 2
      }

      attr_accessor :tokens

      def initialize(raw_line)
        @raw_line = raw_line
        @tokens = parse(raw_line)
        @operations = []

        @expressions = [[]]
      end

      def call
        @tokens.each do |token|
          case token
          when /\d/
            if @expressions.last.empty? || @operations.pop == '*'
              @expressions.last << token.to_i
            else
              index = [@expressions.last.size - 1, 0].max
              @expressions.last[index] = (@expressions.last[index] || 0) + token.to_i
            end
          when /\+/
            @operations << token
          when /\*/
            @operations << token
          when '('
            @expressions << []
          when ')'
            evaluate_expression = @expressions.pop.reduce(&:*)


            if @expressions.last.empty? || (!@operations.empty? && @operations.pop == '*')
              @expressions.last << evaluate_expression
            else
              index = [@expressions.last.size - 1, 0].max
              @expressions.last[index] = (@expressions.last[index] || 0) + evaluate_expression
            end
          end
        end

        @expressions.last.reduce(&:*)
      end

      def parse(raw_line)
        raw_line.tr(' ', '').chars
      end
    end

    class Puzzle18 < ::Aoc::PuzzleBase
      def initialize
        @result = 0
        super()
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        @result += @math_class.new(line).call
      end

      def unit_tests
        assert_equal 26, ClassicMath.new('2 * 3 + (4 * 5)').call
        assert_equal 71, ClassicMath.new('1 + 2 * 3 + 4 * 5 + 6').call

        assert_equal 12240, ClassicMath.new('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))').call

        assert_equal 231, NewMath.new('1 + 2 * 3 + 4 * 5 + 6').call
        assert_equal 46, NewMath.new('2 * 3 + (4 * 5)').call

        test_case = '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'
        assert_equal 23340, NewMath.new(test_case).call

        test_case = '(6 + 5) * 6'
        assert_equal 66, NewMath.new(test_case).call

        test_case = '5 * (4 * (8 * 9 + 7 + 4 + 3 * 2) + (2 * 4 * 7 * 5 + 9 + 2) + (2 + 2 * 9 + 3)) + 8 + 9 + 2 + (4 + 9 + 9 * 2 * (6 * 2 * 4 * 7) + 7)'
        assert_equal 101795, NewMath.new(test_case).call


        test_case = '(4 * (8 * 9 + 7 + 4 + 3 * 2) + (2 * 4 * 7 * 5 + 9 + 2))'
        assert_equal 5056, NewMath.new(test_case).call

        back_to_basic_test_case = '(4*2+3)'
        assert_equal 20, NewMath.new(back_to_basic_test_case).call

        back_to_basic_test_case = '((4*2)+(3*2)*2)'
        assert_equal 28, NewMath.new(back_to_basic_test_case).call

        test_case = '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'
        assert_equal 23340, NewMath.new(test_case).call

        test_case = '5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))'
        assert_equal 669060, NewMath.new(test_case).call
      end
    end
  end
end
