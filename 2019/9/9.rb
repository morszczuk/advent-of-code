require_relative '../../utils/test.rb'
require 'byebug'
require_relative '../shared/intcode.rb'

INTCODE_TEST_DATA = [
  ['input-test1.txt', [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]],
  ['input-test2.txt', [1_219_070_632_396_864]],
  ['input-test3.txt', [1_125_899_906_842_624]]
]

Test.new(INTCODE_TEST_DATA).test_data do |input_filename|
  result = Intcode.new(filename: input_filename).run
  result[:output]
end

class Quiz9A
  def solve
    Intcode.new(filename: 'input.txt', input: [1]).run[:output]
  end
end

class Quiz9B
  def solve
    Intcode.new(filename: 'input.txt', input: [2]).run[:output]
  end
end

pp Quiz9A.new.solve.first
pp Quiz9B.new.solve.first
