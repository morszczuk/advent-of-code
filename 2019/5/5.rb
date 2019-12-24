require_relative '../../utils/test.rb'
require_relative '../shared/intcode.rb'
require 'byebug'

class Quiz5A
  def initialize(input_filename)
    @input_filename = input_filename
    @input = [1]
  end

  def solve
    Intcode.new(filename: @input_filename, input: @input).run[:output]
  end
end

class Quiz5B < Quiz5A
  def solve
    @input = [5]
    super
  end
end

INTCODE_TEST_DATA = [
  [['3,9,8,9,10,9,4,9,99,-1,8',                 [8]], [1]],
  [['3,9,8,9,10,9,4,9,99,-1,8',                 [9]], [0]],
  [['3,9,7,9,10,9,4,9,99,-1,8',                 [7]], [1]],
  [['3,9,7,9,10,9,4,9,99,-1,8',                 [8]], [0]],
  [['3,3,1108,-1,8,3,4,3,99',                   [8]], [1]],
  [['3,3,1108,-1,8,3,4,3,99',                   [9]], [0]],
  [['3,3,1107,-1,8,3,4,3,99',                   [7]], [1]],
  [['3,3,1107,-1,8,3,4,3,99',                   [8]], [0]],
  [['3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9', [1]], [1]],
  [['3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9', [0]], [0]],
  [['3,3,1105,-1,9,1101,0,0,12,4,12,99,1',      [1]], [1]],
  [['3,3,1105,-1,9,1101,0,0,12,4,12,99,1',      [0]], [0]],
  [['3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99', [7]], [999]],
  [['3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99', [8]], [1000]],
  [['3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99', [9]], [1001]],
]

Test.new(INTCODE_TEST_DATA).test_data do |input_data|
  result = Intcode.new(code: input_data.first, input: input_data[1]).run
  result[:output]
end

QUIZ_TEST_DATA = [
  [['input.txt', [1]], [0, 0, 0, 0, 0, 0, 0, 0, 0, 13_978_427]],
  [['input.txt', [5]], [11_189_491]],
]

Test.new(QUIZ_TEST_DATA).test_data do |input_data|
  result = Intcode.new(filename: input_data.first, input: input_data[1]).run
  result[:output]
end

pp Quiz5A.new('input.txt').solve.last
pp Quiz5B.new('input.txt').solve.first
