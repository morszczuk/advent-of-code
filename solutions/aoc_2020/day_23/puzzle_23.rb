module Aoc2020
  module Day23
    class Node
      attr_accessor :next
      attr_reader   :value

      def initialize(value)
        @value = value
        @next  = nil
      end
    end

    # Kudos to https://www.rubyguides.com/2017/08/ruby-linked-list/ for the starting implementation of linked list
    class LinkedList
      attr_reader :head, :size

      def initialize
        @head = nil
        @size = 0
        @tail = nil
        @vals_map = {}
      end

      def append(value)
        if @tail
          @tail.next = Node.new(value)
          @tail.next.next = @head
          @tail = @tail.next
        else
          @head = Node.new(value)
          @head.next = @head
          @tail = @head
        end

        @vals_map[value] = @tail

        @size += 1
      end

      def find_tail
        node = @head
        return node if node.next == @head while (node = node.next)
      end

      def append_after(target, value)
        node           = find(target)

        old_next       = node.next
        node.next      = Node.new(value)
        @vals_map[value] = node.next
        node.next.next = old_next
      end

      def find(value)
        @vals_map[value]
      end

      def print
        node = @head
        res = node.value.to_s
        node = node.next
        while node != @head
          res += node.value.to_s
          node = node.next
        end

        pp res
      end

      def remove_next(node)
        next_next = node.next.next
        node_to_remove = node.next
        @head = node if node_to_remove == @head
        node.next = next_next
        @size -= 1

        node_to_remove
      end
    end

    class CrabsCupListGame
      def initialize(cups)
        @cups = cups
        @current_cup = @cups.head
        @cups_size = @cups.size
      end

      def play(rounds)
        rounds.times do
          three_clockwise = 3.times.map { @cups.remove_next(@current_cup).value }

          destination_cup = @current_cup.value
          loop do
            destination_cup = (destination_cup - 1) % (@cups_size + 1)
            break if destination_cup != @current_cup.value && !three_clockwise.include?(destination_cup) && destination_cup > 0
          end

          three_clockwise.reverse.each { |val| @cups.append_after(destination_cup, val) }
          @current_cup = @current_cup.next
        end

        @cups
      end
    end

    class Puzzle23 < ::Aoc::PuzzleBase
      def handle_input_line(line, *_args)
        @cups, @rounds = line.split(' ')
        @cups = @cups.split('').map(&:to_i)
        @cups_list = LinkedList.new
        @cups.each { |val| @cups_list.append(val) }
        @rounds = @rounds.to_i
      end
    end
  end
end
