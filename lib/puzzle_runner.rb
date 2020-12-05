require 'active_support/core_ext'
require 'byebug'

module AOC
  require 'zeitwerk'
  loader = Zeitwerk::Loader.new
  loader.push_dir(File.dirname(__FILE__) + '/../lib/utils')
  loader.push_dir(File.dirname(__FILE__) + '/../test')
  loader.setup

  class PuzzleRunner
    def initialize(year, day)
      @runner_class = "::Aoc#{year}::Day#{day}::Puzzle#{day}A".constantize
      @input_file = "#{File.dirname(__FILE__)}/../test/aoc_#{year}/day_#{day}/inputs/input.txt"
    end

    def solve(type)
      solution = @runner_class.call(input_file: @input_file)

      pp 'Day 5 - Solution for case A:'
      pp solution
    end
  end
end
