module Aoc2020
  module Day25
    class EncryptionKeyGenerator
      def self.call(subject, loop_size)
        encryption_key = 1
        loop_size.times { encryption_key = Encryptor.call(encryption_key, subject) }
        encryption_key
      end
    end

    class LoopSizeDeterminer
      def initialize(subject = 7)
        @subject = subject
        @loop_results = {}
      end

      def find_loop_size(public_key)
        loop_size = 1
        loop_key = 1

        loop do
          break if (loop_key = Encryptor.call(loop_key, @subject)) == public_key

          loop_size += 1
        end

        loop_size
      end
    end

    class Encryptor
      def self.call(value, subject)
        (value * subject) % 20_201_227
      end
    end

    class Puzzle25 < ::Aoc::PuzzleBase
      def initialize
        @public_keys = []
        super()
      end

      def handle_input_line(line, *_args)
        @public_keys << line.to_i
      end

      def unit_tests
        assert_equal 8, LoopSizeDeterminer.new.find_loop_size(5764801)
        assert_equal 11, LoopSizeDeterminer.new.find_loop_size(17807724)
      end
    end
  end
end
