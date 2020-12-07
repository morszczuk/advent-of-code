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
    # @@assertions
    # self.assertions = 0
    # include Minitest::Assertions
    # include Assertions

    def self.call(input_filename:)
      puzzle = new
      puzzle.parse_input(input_filename) { |line| puzzle.handle_input_line(line) }
      puzzle.solve
    end

    def parse_input(input_filename)
      File.readlines(input_filename).each { |line| yield(line.strip!) }
    end

    def assert_equal(arg_1, arg_2)
      Assertions.assert_equal(arg_1, arg_2)
    end

    def assert(arg_1)
      Assertions.assert(arg_1)
    end
  end
end
