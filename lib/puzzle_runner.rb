require 'active_support/core_ext'
require 'byebug'

module AOC
  require 'zeitwerk'
  loader = Zeitwerk::Loader.new
  loader.push_dir(File.dirname(__FILE__) + '/../lib/utils')
  loader.push_dir(File.dirname(__FILE__) + '/../solutions')
  loader.setup

  class PuzzleRunner

    def initialize(year, day)
      @year = year
      @day = day
    end

    def solve(**options)
      if options['unit']
        puzzle_class('').new.unit_tests
        p 'All tests passed!'
      else
        input_filename = input_filepath(**options)
        options['parts'].chars.each do |part|
          solution = puzzle_class(part).call(input_filename: input_filename)

          if options['input_test']
            pp "Day #{@day} - Test input result for #{part.to_s.capitalize}:"
          else
            pp "Day #{@day} - Solution for case #{part.to_s.capitalize}:"
          end
          pp solution
        end
      end
    end

    private

    def puzzle_class(part)
      "::Aoc#{@year}::Day#{@day}::Puzzle#{@day}#{part.to_s.capitalize}".constantize
    end

    def input_filepath(**options)
      input_filename = input_filename(**options)

      inputs_directory + input_filename
    end

    def input_filename(**options)
      if options['input_test']
        return "test-unit-#{options['input_test_case']}.txt" if options['input_test_case'].present?

        return 'test.txt'
      end

      'input.txt'
    end

    def inputs_directory
      "#{File.dirname(__FILE__)}/../solutions/aoc_#{@year}/day_#{@day}/inputs/"
    end
  end
end
