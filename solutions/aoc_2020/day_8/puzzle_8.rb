module Aoc2020
  module Day8
    class Device
      attr_accessor :accumulator, :instructions

      def initialize
        @instructions = []
      end

      def instruction(id)
        @instructions[id]
      end

      def add_instruction(instruction_type, argument)
        @instructions << [instruction_type, argument.to_i]
      end
    end

    class DeviceRunner
      def initialize(instructions, accumulator: 0, previous_instruction_ids: [], current_instruction_id: 0)
        @instructions = instructions
        @accumulator = accumulator
        @current_instruction_id = current_instruction_id
        @previous_instruction_ids = previous_instruction_ids
      end

      def call
        run_device_instruction until stop_execution?(@current_instruction_id)

        end_type = @current_instruction_id >= @instructions.size ? :success : :loop

        { type: end_type, value: @accumulator }
      end

      def run_device_instruction
        current_instruction = find_current_instruction
        perform_instruction(current_instruction)
        maove_to_the_next_instruction(current_instruction)
      end

      def find_current_instruction
        @instructions[@current_instruction_id]
      end

      def perform_instruction(current_instruction)
        increment_accumulator(current_instruction.last) if accumulate?(current_instruction)
        @previous_instruction_ids << @current_instruction_id
      end

      def maove_to_the_next_instruction(current_instruction)
        @current_instruction_id = next_instruction_id(current_instruction)
      end

      def increment_accumulator(amount)
        @accumulator += amount
      end

      def next_instruction_id(current_instruction)
        return @current_instruction_id += 1 if no_operation?(current_instruction) || accumulate?(current_instruction)

        @current_instruction_id += current_instruction.last if jump?(current_instruction)
      end

      def no_operation?(instruction)
        instruction.first == 'nop'
      end

      def accumulate?(instruction)
        instruction.first == 'acc'
      end

      def jump?(instruction)
        instruction.first == 'jmp'
      end

      def stop_execution?(current_instruction_id)
        @previous_instruction_ids.include?(current_instruction_id) || current_instruction_id >= @instructions.size
      end
    end

    class DeviceFixer < DeviceRunner
      def initialize(instructions)
        super(instructions)
        @fix_attempts = []
      end

      def perform_instruction(current_instruction)
        @fix_attempts << run_fix_attempt(current_instruction) if no_operation?(current_instruction) || jump?(current_instruction)

        super(current_instruction)
      end

      def run_fix_attempt(current_instruction)
        alternate_instruction_type = no_operation?(current_instruction) ? 'jmp' : 'nop'
        alternate_instructions = @instructions.dup
        alternate_instructions[@current_instruction_id] = [alternate_instruction_type, current_instruction.last]

        DeviceRunner.new(
          alternate_instructions, accumulator: @accumulator.dup,
                                  previous_instruction_ids: @previous_instruction_ids.dup,
                                  current_instruction_id: @current_instruction_id.dup
        ).call
      end

      def call
        super

        @fix_attempts.select { |result| result[:type] == :success }.first[:value]
      end
    end

    class Puzzle8 < ::Aoc::PuzzleBase
      def initialize
        @device = Device.new
        super()
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line)
        @device.add_instruction(*line.split(' '))
      end

      def unit_tests
      end
    end
  end
end
