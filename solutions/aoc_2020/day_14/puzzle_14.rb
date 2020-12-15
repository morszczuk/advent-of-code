module Aoc2020
  module Day14
    class ApplyMask
      def initialize(mask)
        @mask = mask
      end

      def call(number)
        result = number
        result = ~result
        result |= @mask.zeros_mask
        result = ~result

        result |= @mask.ones_mask
        result
      end
    end

    class ApplyFloatingMask
      def initialize(binary_mask)
        @binary_mask = binary_mask
      end

      def call(number)
        result = @binary_mask.apply_binary(number)
        @binary_mask.apply_floating(result).uniq
      end

    end

    class Memory
      attr_accessor :mask, :memory_entries

      def initialize
        @mask = nil
        @memory_entries = {}
      end

      def set_memory(mem_id, number)
        @memory_entries[mem_id] = apply_mask(number)
      end

      def apply_mask(number)
        ApplyMask.new(@mask).call(number)
      end
    end

    class MemoryWithMemIdMasked < Memory
      def set_memory(mem_ids, number)
        memory_ids_to_write = apply_mask(mem_ids)
        memory_ids_to_write.each { |mem_id| @memory_entries[mem_id] = number }
      end

      def apply_mask(mem_id)
        ApplyFloatingMask.new(@mask).call(mem_id.to_i)
      end
    end

    class Mask
      attr_reader :ones_mask, :zeros_mask, :zeros_mask_binary, :ones_mask_binary

      def initialize(zeros_mask_binary, ones_mask_binary)
        @zeros_mask_binary = zeros_mask_binary
        @ones_mask_binary = ones_mask_binary

        @zeros_mask = zeros_mask_binary.to_i(2)
        @ones_mask = ones_mask_binary.to_i(2)
      end

      def self.parse(raw_mask)
        new(*parse_masks(raw_mask))
      end

      def self.parse_masks(raw_mask)
        zeros_mask_binary = raw_mask.tr('1', 'Y').tr('0', '1').tr('X', '0').tr('Y', '0')
        ones_mask_binary = raw_mask.tr('0', 'Y').tr('X', '0').tr('Y', '0')


        [zeros_mask_binary, ones_mask_binary]
      end
    end

    class BinaryMask
      def initialize(raw_mask)
        @raw_mask = raw_mask
        @binary_mask = raw_mask.tr('X', '0')
        @floating_mask = raw_mask.tr('0', 'Y').tr('1', 'Y').tr('X', '1').tr('Y', '0')

        @floating_mask_combinations = create_mask_combinations(@floating_mask)
      end

      def self.parse(raw_mask)
        new(raw_mask)
      end

      def apply_binary(number)
        @binary_mask.to_i(2) | number
      end

      def apply_floating(number)
        binary_number = change_to_binary(number)
        @floating_mask_combinations.map do |changes|
          result_number = binary_number.dup
          changes.each { |position, bit| result_number[position] = bit }
          result_number.to_i(2)
        end
      end

      def create_mask_combinations(floating_mask)
        positions = floating_mask.chars.each_with_index.select { |bit, _index| bit == '1' }.map(&:last)

        positions.product(['0', '1']).combination(positions.size)
      end

      def change_to_binary(number)
        result_number = '0' * 36
        string_number = number.to_s(2)
        string_number.size.times do |i|
          result_number[36 - string_number.size + i] = string_number[i]
        end
        result_number
      end
    end

    class Puzzle14 < ::Aoc::PuzzleBase
      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        case line
        when /mask =/
          raw_mask = line.split('mask = ').last
          @memory.mask = @mask_class.parse(raw_mask)
        when /mem\[/
          matched = /mem\[(?<mem_id>.*)\] = (?<number>.*)/.match(line)
          @memory.set_memory(matched[:mem_id], matched[:number].to_i)
        end
      end

      def unit_tests
        mask = Mask.parse('XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X')
        assert_equal 73, ApplyMask.new(mask).call(11)
        assert_equal 101, ApplyMask.new(mask).call(101)
        assert_equal 64, ApplyMask.new(mask).call(0)

        mask = BinaryMask.new('000000000000000000000000000000X1001X')
        assert_equal [26, 27, 58, 59].sort, ApplyFloatingMask.new(mask).call(42).sort
        mask = BinaryMask.new('00000000000000000000000000000000X0XX')
        assert_equal [16, 17, 18, 19, 24, 25, 26, 27].sort, ApplyFloatingMask.new(mask).call(26).sort
      end
    end
  end
end
