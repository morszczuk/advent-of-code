module Aoc2021
  module Day4
    class BingoCard
      def initialize(card_numbers)
        @card_numbers = card_numbers
        @numbers = @card_numbers.flatten
        @hits = []
      end

      def mark_draw(draw)
        @hits << draw if @numbers.include? draw

        self
      end

      def winning?
        any_fully_marked?(@card_numbers) || any_fully_marked?(@card_numbers.transpose)
      end

      def endpoint
        (@numbers - @hits).sum * @hits.last
      end

      private

      def any_fully_marked?(numbers_list)
        numbers_list.any? { |list| list.all? { |elem| @hits.include? elem } }
      end
    end

    class BingoGame
      def initialize(draws, cards)
        @draws = draws
        @cards = cards
      end

      def play
        @draws.each do |draw|
          result = round(draw)

          return result unless result == :none_winning
        end

         :none
      end

      def round(draw)
        winner = @cards.map { |card| card.mark_draw(draw) }.find(&:winning?)

        winner || :none_winning
      end
    end

    class BingoGame2 < BingoGame
      def initialize(...)
        super
        @winning_cards = []
      end

      def round(draw)
        winners = @cards.map { |card| card.mark_draw(draw) }.select(&:winning?)

        @winning_cards += winners
        @cards -= winners

        @cards.empty? ? @winning_cards.last : :none_winning
      end
    end

    class Puzzle4 < ::Aoc::PuzzleBase
      def initialize
        @last_empty = false
        @cards = []
        @draws = nil
      end

      def solve(bingo_class)
        @cards << BingoCard.new(@new_card_numbers)
        game = bingo_class.new(@draws, @cards)

        winning_card = game.play
        winning_card.endpoint
      end

      def handle_input_line(line, *_args)
        return @draws = line.split(',').map(&:to_i) if line.include? ','

        if line.empty?
          @cards << BingoCard.new(@new_card_numbers) if @new_card_numbers.present?
          @last_empty = true
        elsif @last_empty
          @new_card_numbers = []
          @new_card_numbers << line.split(' ').map(&:to_i)
          @last_empty = false
        else
          @new_card_numbers << line.split(' ').map(&:to_i)
        end
      end

      def unit_tests
      end
    end
  end
end
