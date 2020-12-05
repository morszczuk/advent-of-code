require_relative './puzzle_runner'

class Puzzle < Thor
  include Thor::Actions

  CURRENT_YEAR = '2020'.freeze

  desc 'solve day_number', 'Run puzzle'
  method_option :input, aliases: '-i', default: false, type: :boolean
  method_option :input_case, aliases: '-c', default: false, type: :boolean
  method_option :unit, aliases: '-u', default: false, type: :boolean
  method_option :part, aliases: '-p', default: 'a'
  method_option :year, aliases: '-y', default: CURRENT_YEAR

  def solve(day_number)
    @day_number = day_number
    year = options[:year]
    puzzle_runner = ::AOC::PuzzleRunner.new(year, @day_number)

    puzzle_runner.solve(:input) if options.input?
  end

  no_commands do
    def input_file_path
      "#{target_directory}inputs/input.txt"
    end

    def target_directory
      test_path = "../test/"
      day_path = "#{year}/#{day}/"

      test_path + day_path
    end
  end

  def self.exit_on_failure?
    true
  end

  def self.source_root
    File.dirname(__FILE__)
  end
end
