require_relative '../../utils/test.rb'
require 'byebug'

class Puzzle5A
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

class Puzzle5B < Puzzle451A
  def solve
  end
end

Test.new(TEST_DATA).test_data do |input|
  Puzzle%day%A.new.solve input
end

# Test.new(TEST_DATA_2).test_data do |input|
  # Puzzle5B.new.solve input
# end

pp Puzzle5A.new('input.txt').solve
# pp Puzzle5B.new('input.txt').solve

# Replace 451
