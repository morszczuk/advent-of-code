require_relative './puzzle_runner'

class Puzzle < Thor
  include Thor::Actions

  CURRENT_YEAR = '2021'.freeze

  desc 'solve day_number', 'Run puzzle'
  method_option :input, aliases: '-i', default: false, type: :boolean
  method_option :input_test, aliases: '-t', default: false, type: :boolean
  method_option :input_test_case, aliases: '-c'
  method_option :unit, aliases: '-u', default: false, type: :boolean
  method_option :parts, aliases: '-p', default: 'ab'
  method_option :year, aliases: '-y', default: CURRENT_YEAR

  def solve(day_number)
    @day_number = day_number
    year = options[:year]
    puzzle_runner = ::AOC::PuzzleRunner.new(year, @day_number)

    puzzle_runner.solve(**options)
  end

  def self.exit_on_failure?
    true
  end

  def self.source_root
    File.dirname(__FILE__)
  end
end
