module Aoc2021
  module Day13
    class Puzzle13 < ::Aoc::PuzzleBase
      def initialize
        @card = {}
        @folds = []
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        return if line.empty?
        if line.include?('fold along')
          fold = line.tr('fold along ', '').split('=')
          fold[1] = fold[1].to_i
          @folds << fold
        else
          @card[line.split(',').map(&:to_i)] = true
        end
      end

      def print_card(card)
        width = card.keys.map(&:first).max
        height = card.keys.map(&:last).max

        res = (height + 1).times.map do |y|
          row = (width + 1).times.map do |x|
            card.key?([x, y]) ? '#' : '.'
          end.join('')
        end
        puts res.join("\n")
        puts "\n\n"
      end

      def fold(card, axis, line_coord)
        folded_card = {}
        coord_to_consider = axis == 'x' ? 0 : 1
        card.keys.reject { |c| c[coord_to_consider] == line_coord }.each do |coord|
          if coord[coord_to_consider] < line_coord
            folded_card[coord] = true
          else
            new_coord = coord
            new_coord[coord_to_consider] = line_coord - (coord[coord_to_consider] - line_coord)
            folded_card[new_coord] = true
          end
        end

        folded_card
      end

      def unit_tests
      end
    end
  end
end
