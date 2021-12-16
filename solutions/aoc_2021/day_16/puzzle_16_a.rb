module Aoc2021
  module Day16
    class Puzzle16A < Puzzle16
      PACKET_PARSERS = {
        0 => ->(res) { res.sum },
        1 => ->(res) { res.reduce(&:*) },
        2 => ->(res) { res.min },
        3 => ->(res) { res.max },
        4 => :packet_type_4,
        5 => ->(res) { res.first > res.last ? 1 : 0  },
        6 => ->(res) { res.first < res.last ? 1 : 0  },
        7 => ->(res) { res.first == res.last ? 1 : 0  },
      }

      # too low - 34382179868
      # too low - 34382179868
      # too low - 3381483850
      def solve
        version_sums = []
        results = []
        @lines_to_process.map do |line_to_process|
          @version_sum = 0
          res = process(line_to_process)
          pp "res: #{res}"
          results << res
          version_sums << @version_sum
          pp @version_sum
        end
        # @res = []
        # res = process(@line_to_process)
        # pp res

        # pp @res
        version_sums
        results
        # res
      end

      def process(line_to_process)
          # byebug
          puts "\n\n\n"
          pp line_to_process
          return nil if line_to_process.empty? || line_to_process.size < 4
        # until line_to_process.empty?
          packet_version = line_to_process.slice!(0..2).to_i(2)
          packet_type_id = line_to_process.slice!(0..2).to_i(2)
          # pp "Packet version, packet type:"
          # pp [packet_version, packet_type_id]
          # puts "\n\n\n"

          @version_sum += packet_version

          puts "packet version: #{packet_version}"
          puts "packet type id: #{packet_type_id}"
          if packet_type_id == 4
            pp :packet_type_4
            # pp line_to_process
            # puts "\n\n"
            # method(PACKET_PARSERS[packet_type_id]).call(line_to_process)
            # byebug
            res = [packet_type_4(line_to_process)]
            until line_to_process.empty? do
              res << process(line_to_process)
              line_to_process = '' if line_to_process.size < 4
            end
            # if line_to_process.
            return res.flatten
          else
            type = line_to_process.slice!(0) == '0' ? :total_length : :number_of_packets

            case type
            when :total_length
              total_length = line_to_process.slice!(0..14).to_i(2)
              pp :total_length
              # pp line_to_process
              pp total_length
              # puts "\n\n"
              result = []
              # until line_to_process.empty? do
              full_line = line_to_process.slice!(0..total_length-1)

              until full_line.empty? do
                # byebug
                result << process(full_line)
              end
              result = result.flatten.compact
              return nil if result.empty?
              # end
              # pp result
              # pp packet_type_id
              # byebug
              return PACKET_PARSERS.key?(packet_type_id) ? PACKET_PARSERS[packet_type_id].call(result) : result
            when :number_of_packets
              pp :number_of_packets
              return nil if line_to_process.empty?
              # pp line_to_process
              subpackets = line_to_process.slice!(0..10).to_i(2)
              pp "Number of packets: #{subpackets}"
              # puts "\n\n"
              result = subpackets.times.map { process(line_to_process) }.flatten.compact
              # result = subpackets.times.map { process(line_to_process.slice!(0..10)) }.flatten.compact
              return nil if result.empty?
              # byebug
              return PACKET_PARSERS.key?(packet_type_id) ? PACKET_PARSERS[packet_type_id].call(result) : result
            end
            # length = line_to_process.slice!(0) == '1' ? 10 : 14


            # byebug


            # pp result
            # byebug

            # pp results
            # byebug
            # pp length
            # byebug

          # end
        end

        # pp packet_version
        # pp line_to_process
        # byebug
      end

      def packet_type_4(line_to_process)
        continue_parsing = true
        res = ''
        while continue_parsing do
          continue_parsing = line_to_process.slice!(0) == '1'
          res += line_to_process.slice!(0..3)
        end
        res.to_i(2)
      end
    end
  end
end

