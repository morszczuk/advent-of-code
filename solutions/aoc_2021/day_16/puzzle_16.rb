module Aoc2021
  module Day16
    class PacketDecoder
      PACKET_PARSERS = {
        0 => ->(res) { res.sum },
        1 => ->(res) { res.reduce(&:*) },
        2 => ->(res) { res.min },
        3 => ->(res) { res.max },
        5 => ->(res) { res.first > res.last ? 1 : 0  },
        6 => ->(res) { res.first < res.last ? 1 : 0  },
        7 => ->(res) { res.first == res.last ? 1 : 0  },
      }

      OPERATOR_TYPE = {
        '0' => :total_length,
        '1' => :number_of_packets
      }

      def initialize(message)
        @message = message
      end

      def process
        @version_sum = 0
        decoded_message = process_part(@message)

        { decoded_message: decoded_message, version_sum: @version_sum }
      end

      def process_part(part)
        packet_version = slice(part, 3, :int)
        packet_type_id = slice(part, 3, :int)
        @version_sum += packet_version

        return value_of_packet_type_4(part) if packet_type_id == 4

        sub_packet_values = case OPERATOR_TYPE[slice(part, 1)]
                            when :total_length
                              sub_packets_length = slice(part, 15, :int)
                              sub_packets_line = slice(part, sub_packets_length)
                              sub_packet_values = []
                              until sub_packets_line.empty? do sub_packet_values << process_part(sub_packets_line) end
                              sub_packet_values
                            when :number_of_packets
                              sub_packets_amount = slice(part, 11, :int)
                              sub_packets_amount.times.map { process_part(part) }
                            end

        PACKET_PARSERS[packet_type_id].call(sub_packet_values.flatten.compact)
      end

      def value_of_packet_type_4(part)
        continue_parsing = true
        res = ''
        while continue_parsing do
          continue_parsing = slice(part, 1) == '1'
          res += slice(part, 4)
        end
        res.to_i(2)
      end

      def slice(line, length, format = :string)
        substring = line.slice!(0..(length - 1))

        case format
        when :int
          substring.to_i(2)
        else
          substring
        end
      end
    end

    class Puzzle16 < ::Aoc::PuzzleBase
      def initialize
        @messages_to_process = []
      end

      def solve
        @messages_to_process.map { |message| PacketDecoder.new(message).process }
      end

      def handle_input_line(line, *_args)
        @messages_to_process << line.chars.map { |n| n.to_i(16).to_s(2).rjust(4, '0') }.join('')
      end

      def unit_tests
      end
    end
  end
end
