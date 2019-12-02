require_relative '../../utils/test.rb'
require 'byebug'

TEST_DATA = [
  ['1,0,0,0,99', '2,0,0,0,99'],
  ['2,3,0,3,99', '2,3,0,6,99'],
  ['2,4,4,5,99,0', '2,4,4,5,99,9801'],
  ['1,1,1,4,99,5,6,0,99', '30,1,1,4,2,5,6,0,99']
]

class Computer
  ENDING_NUMBER = 99

  def initialize(input, test: false, noun: nil, verb: nil)
    @noun = noun
    @verb = verb
    parse_input(input, test)
  end

  def result
    while true
      return @integer_table if ending_symbol_occurred?
      do_round(@current_round)
      @current_round += 1
    end
  end

  private

  def parse_input(input, test)
    @integer_table = input.split(',').map(&:to_i)
    replace_initial_state unless test
    @ending_location = @integer_table.find_index(99)
    @number_of_rounds = @ending_location / 4
    @current_round = 0
  end

  def do_round(round)
    operation, *source, destination = @integer_table[round*4..round*4 + 3]
    source = source.map { |i| @integer_table[i] }
    value = operation == 1 ? source.sum : source.inject(:*)
    @integer_table[destination] = value
  end

  def ending_symbol_occurred?
    @integer_table[@current_round * 4] == ENDING_NUMBER
  end

  def replace_initial_state
    @integer_table[1] = @noun
    @integer_table[2] = @verb
  end
end

class Quiz2A
  def self.solve(input, test: false)
    result = Computer.new(input, test: test, noun: 12, verb: 2).result[0]
  end
end

class Quiz2B
  def self.solve(input, test: false)
    expected_result = 19690720
    a = (0..100).to_a
    b = (0..100).to_a
    combinations = a.product(b)

    combinations.each do |noun, verb|
      return noun * 100 + verb if Computer.new(input, noun: noun, verb: verb).result[0] == expected_result
    end
  end
end

Test.new(TEST_DATA).test_data do |input|
  Computer.new(input, test: true, noun: 12, verb: 2).result.join(',')
end

File.readlines('input.txt').each do |line|
  pp "2A Result is: #{Quiz2A.solve(line)}"
  pp "2B Result is: #{Quiz2B.solve(line)}"
end
