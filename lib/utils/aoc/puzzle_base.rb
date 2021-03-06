require 'minitest'

module Aoc
  module Assertions
    extend Minitest::Assertions

    class << self
      attr_accessor :assertions
    end

    self.assertions = 0
  end

  class PuzzleBase
    def self.call(input_filename:)
      puzzle = new
      puzzle.parse_input(input_filename) { |line, index| puzzle.handle_input_line(line, index) }
      puzzle.solve
    end

    def parse_input(input_filename)
      File.readlines(input_filename).each_with_index { |line, index| yield(line.strip!, index) }
    end

    def handle_input_line(line, _index)
      handle_input_line(line)
    end

    def assert_equal(arg_1, arg_2)
      Assertions.assert_equal(arg_1, arg_2)
    end

    def assert(arg_1)
      Assertions.assert(arg_1)
    end
  end
end
