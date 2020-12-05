require_relative '../../utils/test.rb'
require 'byebug'
require 'minitest'


module Assertions
  extend Minitest::Assertions

  class << self
    attr_accessor :assertions
  end

  self.assertions = 0
end

class BinaryParser
  def self.parse(raw_value, char_for_1, char_for_0)
    raw_value.chars.map! do |char|
      case char
      when char_for_1 then 1
      when char_for_0 then 0
      else raise 'Unkonwn'
      end
    end.join('').to_i(2)
  end
end

class SeatIdCalculator
  def self.call(row, col)
    row * 8 + col
  end
end


class Quiz5A
  attr_reader :max_seat_id

  def initialize(input_filename = nil)
    @max_seat_id = -1
    parse_input(input_filename) if input_filename
  end

  def solve
    @max_seat_id
  end

  def parse_input(input_filename)
    File.readlines(input_filename).each do |line|
      row = BinaryParser.parse(line[0, 7], 'B', 'F')
      col = BinaryParser.parse(line[7, 3], 'R', 'L')

      seat_id = SeatIdCalculator.call(row, col)
      @max_seat_id = seat_id if seat_id > @max_seat_id
    end
  end
end

class Quiz5B < Quiz5A
  def initialize(input_filename = nil)
    @seats = {}
    parse_input(input_filename) if input_filename
  end

  def solve
    sorted_seats = @seats.keys.sort
    first_seat = sorted_seats.first
    your_seat_id = sorted_seats.each_with_index.detect do |seat_id, id|
      id + first_seat != seat_id
    end

    your_seat_id.first - 1
  end

  def parse_input(input_filename)
    File.readlines(input_filename).each do |line|
      row = BinaryParser.parse(line[0, 7], 'B', 'F')
      col = BinaryParser.parse(line[7, 3], 'R', 'L')

      seat_id = SeatIdCalculator.call(row, col)
      @seats[seat_id] = true
    end
  end
end

pp Quiz5B.new('input.txt').solve

