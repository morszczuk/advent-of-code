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

TEST_DATA = [
  ['input-test1.txt', '0 3 6 9 2 5 8 1 4 7'],
  ['input-test2.txt', '3 0 7 4 1 8 5 2 9 6'],
  ['input-test3.txt', '6 3 0 7 4 1 8 5 2 9'],
  ['input-test4.txt', '9 2 5 8 1 4 7 0 3 6'],
]

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

class Deck
  attr_reader :deck

  def initialize(size)
    @deck = (0..(size - 1)).to_a
    # byebug
  end
end

class BasicDeal
  def initialize(deck)
    @deck = deck
  end
end

class ReversableDeal < BasicDeal
  def deal
    @deck.reverse
  end
end

class CutDeal < BasicDeal
  def deal(number_to_cut)
    part_to_move = number_to_cut > 0 ? @deck.slice!(0, number_to_cut) : @deck.slice!(@deck.size - number_to_cut.abs, number_to_cut.abs)

    number_to_cut > 0 ? @deck + part_to_move : part_to_move + @deck
  end
end

class IncrementDeal < BasicDeal
  def deal(increment)
    new_deck = []
    @deck.size.times do |iteration|
      index = (iteration * increment) % @deck.size
      new_deck[index] = @deck[iteration]
    end
    new_deck
  end
end

class Quiz22A
  def initialize(filename, size = 10)
    @filename = filename
    @size = size
    @deck = Deck.new(@size).deck
    byebug
  end

  def solve
    File.readlines(@filename).each do |line|
      case line
      when /deal into new stack.*/
        @deck = ReversableDeal.new(@deck).deal
      when /cut.*/
        cut = /cut (.*)/.match(line).captures.first.to_i
        @deck = CutDeal.new(@deck).deal(cut)
      when /deal with increment.*/
        increment = /deal with increment (.*)/.match(line).captures.first.to_i
        @deck = IncrementDeal.new(@deck).deal(increment)
      end
    end
    @deck
    # reversed_deal = ReversableDeal.new(deck).deal
    # reversed_deal = deck 
    # cut_deal = CutDeal.new(reversed_deal).deal(-4)
    # cut_deal = deck
    # increment_deal = IncrementDeal.new(cut_deal).deal(3)
  end

  def parse_input(input_filename)
    File.readlines(input_filename).each do |line|
      # line.strip.split(',').map { |entry| entry.match(/([A-Z])(\d+)/).captures }
      # line.match(/([A-Z])(\d+)/).captures
    end
  end
end

class Quiz22B < Quiz22A
  def solve(repetition)
    repetition.times do 
      @deck = super
    end
  end
end

# TEST_DATA = [
#   # [10, '9,8,7,6,5,4,3,2,1,0']
#   # [10, '3 4 5 6 7 8 9 0 1 2']
#   # [10, '6 7 8 9 0 1 2 3 4 5']
#   [10, '0 7 4 1 8 5 2 9 6 3']
# ]

# Test.new(TEST_DATA).test_data do |filename|
#   Quiz22A.new(filename, 10).solve.join(' ')
# end

# Test.new(TEST_DATA_2).test_data do |number|
#   Quiz22B.new.solve
# end


pp Quiz22B.new('input.txt', 119_315_717_514_047).solve(101_741_582_076_661).find_index(2020)
# pp Quiz22A.new.solve
# pp Quiz22B.new('input.txt').solve

# Replace 22
