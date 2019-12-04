require_relative '../../utils/test.rb'
require 'byebug'

# TEST_DATA = [
#   ['', ''],
#   ['', ''],
#   ['', ''],
# ]

# TEST_DATA = [
#   ['', ],
#   ['', ],
#   ['', ],
# ]

# TEST_DATA = [
#   [111111, true],
#   [223450, false],
#   [123789, false],
# ]

# TEST_DATA_2 = [
#   [112233, true],
#   [123444, false],
#   [111122, true],
# ]

# TEST_DATA = [
#   ['input-test1.txt', ],
#   ['input-test2.txt', ],
#   ['input-test3.txt', ],
# ]

# TEST_DATA = [
#   ['input-test1.txt', ''],
#   ['input-test2.txt', ''],
#   ['input-test3.txt', ''],
# ]

# TEST_DATA = [
#   ['1,0,0,0,99', '2,0,0,0,99'],
#   ['2,3,0,3,99', '2,3,0,6,99'],
#   ['2,4,4,5,99,0', '2,4,4,5,99,9801'],
#   ['1,1,1,4,99,5,6,0,99', '30,1,1,4,2,5,6,0,99']
# ]

# TEST_DATA_2 = [
#   ['input-test1.txt', 30],
#   ['input-test2.txt', 610],
#   ['input-test3.txt', 410],
# ]

class Quiz451A
  def initialize(input_filename = nil)
    parse_input(input_filename) if input_filename
  end

  def solve
  end

  def parse_input(input_filename)
    File.readlines(input_filename).each do |line|
      # line.strip.split(',').map { |entry| entry.match(/([A-Z])(\d+)/).captures }
      # line.match(/([A-Z])(\d+)/).captures
    end
  end
end

class Quiz451B < Quiz451A
  def solve
  end
end

Test.new(TEST_DATA).test_data do |number|
  Quiz451A.new.potential_password? number.digits.reverse
end

# Test.new(TEST_DATA_2).test_data do |number|
#   Quiz451B.new.potential_password? number.digits.reverse
# end

pp Quiz451A.new('input.txt').solve
# pp Quiz451A.new.solve
# pp Quiz451B.new('input.txt').solve

# Replace 451
