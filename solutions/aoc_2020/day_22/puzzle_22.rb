module Aoc2020
  module Day22
    class Game
      def initialize(decks)
        @decks = decks
        @winning_count = decks.values.flatten.size
      end

      def play
        loop do
          @winning_deck = @decks.values.select { |deck_cards| deck_cards.size == @winning_count }.first
          break unless @winning_deck.nil?

          card_1 = @decks[:player_1].shift
          card_2 = @decks[:player_2].shift

          winner = card_1 > card_2 ? :player_1 : :player_2

          @decks[winner] += [card_1, card_2].sort.reverse
        end

        calculate_result(@winning_deck)
      end

      def calculate_result(winning_deck)
        winning_deck.each_with_index.sum do |card, index|
          card * (winning_deck.size - index)
        end
      end
    end

    class RecursiveGame < Game
      def initialize(decks, recurse_level = 0)
        super(decks)
        @previous_decks = {}
      end

      def play
        loop do
          unless @previous_decks[stringify_current_decks].nil?
            @game_winner = :player_1
            break
          end

          @previous_decks[stringify_current_decks] = true

          card_1 = @decks[:player_1].shift
          card_2 = @decks[:player_2].shift

          if @decks[:player_1].size >= card_1 && @decks[:player_2].size >= card_2
            decks_for_recursive_play = {
              player_1: @decks[:player_1].first(card_1),
              player_2: @decks[:player_2].first(card_2)
            }

            round_winner = RecursiveGame.new(decks_for_recursive_play.deep_dup, @recurse_level).play.first
          else
            round_winner = card_1 > card_2 ? :player_1 : :player_2
          end

          cards_to_add = [card_1, card_2]
          cards_to_add.reverse! if round_winner == :player_2
          @decks[round_winner] += cards_to_add

          next unless (losing_deck = @decks.select { |_p, deck| deck.empty? }.first).present?

          @game_winner = losing_deck.first == :player_1 ? :player_2 : :player_1
          break
        end

        [@game_winner, calculate_result(@decks[@game_winner])]
      end

      def deck_has_already_happenned?
        current_deck = stringify_current_decks
        @previous_decks.any? { |previous_deck| previous_deck == current_deck }
      end

      def stringify_current_decks
        "#{@decks[:player_1].join(',')}|#{@decks[:player_2].join(',')}"
      end
    end

    class Puzzle22 < ::Aoc::PuzzleBase
      attr_reader :decks

      def initialize
        @decks = { player_1: [], player_2: [] }
        @current_player = :player_1
        super()
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        return if line.empty? || line.include?('Player 1')
        return @current_player = :player_2 if line.include?('Player 2')

        @decks[@current_player] << line.to_i
      end
    end
  end
end
