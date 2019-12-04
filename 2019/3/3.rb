require_relative '../../utils/test.rb'
require 'byebug'

TEST_DATA = [
  ['input-test1.txt', 6],
  ['input-test2.txt', 159],
  ['input-test3.txt', 135],
]

TEST_DATA_2 = [
  ['input-test1.txt', 30],
  ['input-test2.txt', 610],
  ['input-test3.txt', 410],
]

class Quiz3A
  def initialize(input_filename)
    @wires = []
    @position = [0,0]
    parse_input(input_filename)
  end

  def solve
    (@wires[0] & @wires[1]).map { |point| distance(point) }.min
  end

  def parse_input(input_filename)
    File.readlines(input_filename).each do |line|
      @position = [0, 0]
      @wires << parse_wire(line) unless line.empty?
    end
  end

  def parse_wire(line)
    wire = line.strip.split(',').map { |entry| entry.match(/([A-Z])(\d+)/).captures }
    wire.map! do |direction, number_of_steps|
      generate_steps(direction, number_of_steps.to_i)
    end
    wire.flatten(1)
  end

  def generate_steps(direction, number_of_steps)
    upwards        = %w[D R].include?(direction)
    changing_axis  = %w[U D].include?(direction) ? 0 : 1
    remaining_axis = (changing_axis + 1) % 2

    starting_index = @position[changing_axis]
    range = upwards ? (starting_index + 1)..(starting_index + number_of_steps) : (starting_index - 1).downto(starting_index - number_of_steps)
    steps = range.map { |step| [step].insert(remaining_axis, @position[remaining_axis]) }
    @position = steps.last

    steps
  end

  def distance(point)
    point[0].abs + point[1].abs
  end
end

class Quiz3B < Quiz3A
  def solve
    (@wires[0] & @wires[1]).map { |point| @wires[0].find_index(point) + @wires[1].find_index(point) + 2 }.min
  end
end

Test.new(TEST_DATA).test_data do |input|
  Quiz3A.new(input).solve
end

Test.new(TEST_DATA_2).test_data do |input|
  Quiz3B.new(input).solve
end

pp Quiz3A.new('input.txt').solve
pp Quiz3B.new('input.txt').solve
