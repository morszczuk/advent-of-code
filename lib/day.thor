require_relative './day_input_fetcher'

class Day < Thor
  include Thor::Actions

  CURRENT_YEAR = '2021'

  desc 'setup day_number', 'Creates directory structure and downloads input file from AoC website.'
  method_option :year, aliases: '-y', desc: "Specify puzzle year. Default: #{CURRENT_YEAR}", default: CURRENT_YEAR

  def setup(day_number)
    @day_number = day_number
    directory './templates', target_directory

    insert_into_file input_file_path do
      DayInputFetcher.new(year, day).call
    end
  end

  no_commands do
    def year
      options[:year] || CURRENT_YEAR
    end

    def day
      @day_number
    end

    def input_file_path
      "#{target_directory}inputs/input.txt"
    end

    def target_directory
      solutions_path = "../solutions/"
      day_path = "aoc_#{year}/day_#{day}/"

      solutions_path + day_path
    end
  end

  def self.exit_on_failure?
    true
  end

  def self.source_root
    File.dirname(__FILE__)
  end
end
