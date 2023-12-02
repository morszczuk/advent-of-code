module Aoc2023
  module Day2
    class Puzzle2 < ::Aoc::PuzzleBase
      def initialize
        @games = {}
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        game_id, sets = line.split(':')
        game_id = game_id.sub('Game ', '').to_i
        sets = sets.split(';')
        @games[game_id] = sets.map do |set|
          moves_in_set = set.split(',').map do |m|
            number, color = m.strip.split(' ')
            number = number.to_i
            [color, number]
          end.to_h
        end
      end

      def unit_tests
      end
    end
  end
end
