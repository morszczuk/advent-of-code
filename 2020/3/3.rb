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

class MapTraverser
  attr_reader :steps_count

  def initialize(map_sample, movement_x = 3, movement_y = 1)
    @map_sample = map_sample
    @map_accessor = MapAccessor.new(@map_sample)
    @trees_count = 0
    @steps_count = 0
    @position = [0, 0]
    @movement = [movement_x, movement_y]
  end

  def traverse
    make_step until end_of_map?

    @trees_count
  end

  def end_of_map?
    @position[1] == @map_sample.height - 1
  end

  def make_step
    # byebug
    @position = [@position, @movement].transpose.map(&:sum)
    value = @map_accessor.element_at(*@position)
    # pp value
    @steps_count += 1
    @trees_count += value
  end
end

class MapAccessor
  def initialize(map_sample)
    @map_sample = map_sample
    @sample_width = @map_sample.width
  end

  def element_at(x, y)
    sample_x = calculate_sample_x(x)

    # pp [x, sample_x, @sample_width]

    value = @map_sample[sample_x, y]
    byebug if value.nil?
    value

  end

  def calculate_sample_x(x)
    x % @sample_width
  end
end

class MapSample
  SQUARE = 0
  TREE = 1

  attr_accessor :sample

  def initialize()
    @sample = []
  end

  def [](x, y)
    # byebug
    # pp @sample[y]
    # pp x
    # pp y
    # byebug
    @sample[y][x]
  end

  def width
    @width ||= @sample.first.size
  end

  def height
    @height ||= @sample.size
  end

  def parse_line(line)
    @sample << line.split('').map!(&method(:identify_element)).compact!
  end

  private

  def identify_element(element)
    case element
    when '.' then SQUARE
    when '#' then TREE
    end
  end
end

class Quiz3A
  attr_accessor :traverser

  def initialize(input_filename = nil)
    @map_sample = MapSample.new

    parse_input(input_filename) if input_filename
  end

  def solve
    @traverser = MapTraverser.new(@map_sample)
    result = @traverser.traverse
    # pp @traverser.steps_count
    result
  end

  def parse_input(input_filename)
    File.readlines(input_filename).each do |line|
      @map_sample.parse_line(line)
      # line.strip.split(',').map { |entry| entry.match(/([A-Z])(\d+)/).captures }
      # line.match(/([A-Z])(\d+)/).captures
    end
  end
end

class Quiz3B < Quiz3A
  def solve
    trees = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]].map! do |movement|
      # pp movement
      MapTraverser.new(@map_sample, *movement).traverse
      # traverser.
    end

    pp trees
    trees.reduce(&:*)
  end
end

# Test.new(TEST_DATA).test_data do |input|
#   Quiz3A.new.solve input
# end

# Test.new(TEST_DATA_2).test_data do |input|
  # Quiz3B.new.solve input
# end

# pp Quiz3A.new('test.txt').solve
# pp Quiz3A.new('input-test-2.txt').solve
# pp Quiz3A.new('input.txt').solve
# pp Quiz3A.new.solve
pp Quiz3B.new('input.txt').solve

# Replace 3
