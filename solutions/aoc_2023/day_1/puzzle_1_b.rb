module Aoc2023
  module Day1
    class Puzzle1B < Puzzle1
      MAPPING = {
        'one' => '1',
        'two' => '2',
        'three' => '3',
        'four' => '4',
        'five' => '5',
        'six' => '6',
        'seven' => '7',
        'eight' => '8',
        'nine' => '9'
      }

      def solve
        @inputs.map do |line|
          regex = /(?=(one|two|three|four|five|six|seven|eight|nine))/

          res = line.to_enum(:scan, regex).map { last = Regexp.last_match; pp last[1]; [MAPPING[last[1]], last.offset(0)[0]] }
          first = res.first
          last = res.last

          line[first.last] = first.first if first.present?
          line[last.last] = last.first if last.present?

          "#{/\d/.match(line)}#{/\d/.match(line.reverse)}".to_i
        end.sum
      end
    end
  end
end

