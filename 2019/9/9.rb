require_relative '../../utils/test.rb'
require 'byebug'
require "ostruct"

class OpsCodeParser
  def self.call(ops_code)
    digits = ops_code.digits
    operation = "#{digits[1]}#{digits[0]}".to_i
    modes = (2..4).map { |fd| digits[fd].nil? ? 0 : digits[fd] }

    [operation, modes]
  end
end

class Computer
  attr_reader :stopped
  attr_accessor :inputs

  ENDING_NUMBER = 99

  def initialize(input)
    @current_pointer = 0
    parse_input(input)
    @output = []
    @stopped = false
    @relative_base = 0
  end

  def run(inputs: [])
    @inputs = inputs
    loop do
      @code_break = do_round
      break if @code_break == :halt || @code_break == :input_empty
    end
# byebug
    OpenStruct.new(code: @code_break, output: @output)
  end

  def add_input(input)
    @inputs << input
  end

  # def proceed
  #   if @stopped
  #     @

  # end

  def parse_input(input)
    @integer_table = input.split(',').map(&:to_i)
  end

  def do_round
    operation, modes = OpsCodeParser.call(@integer_table[@current_pointer])
    # byebug

    # pp "current pointer #{@current_pointer} value: #{@integer_table[@current_pointer]} Opeation: #{operation}, modes: #{modes}"

    return :halt if operation == ENDING_NUMBER

    case operation
    when 1, 2
      source = [@integer_table[@current_pointer+1], @integer_table[@current_pointer+2]]
      byebug if modes[2] == 1
      destination = @integer_table[@current_pointer+3]
      # byebug
      source = [0, 1].map { |i|  position_value(source[i], modes[i]) }
      byebug
      value = operation == 1 ? source.sum : source.inject(:*)

      @integer_table[destination] = value
      @current_pointer += 4
    when 3
      pp "OPTCODE 3. Provided input: #{@inputs.first}"
      if @inputs.empty?
        return :input_empty
        # @stopped = true

        # @inputs.empty?
      end
      # byebug
      # && @output.empty?
      input_value = @inputs.shift
      # || @output.shift
      # @integer_table[@integer_table[@current_pointer+1]] = input_value
      @integer_table[input_param(0, modes)] = input_value
      @current_pointer += 2
    when 4
      @output << parameter_in_mode(0, modes)
      # pp "Current output: #{@output}"
      @current_pointer += 2
    when 5
      parameter_in_mode(0, modes) != 0 ? @current_pointer = parameter_in_mode(1, modes) : @current_pointer += 3
    when 6
      parameter_in_mode(0, modes).zero? ? @current_pointer = parameter_in_mode(1, modes) : @current_pointer += 3
    when 7
      value = parameter_in_mode(0, modes) < parameter_in_mode(1, modes) ? 1 : 0
      @integer_table[@integer_table[@current_pointer + 3]] = value

      @current_pointer += 4
    when 8
      value = parameter_in_mode(0, modes) == parameter_in_mode(1, modes) ? 1 : 0
      @integer_table[@integer_table[@current_pointer + 3]] = value

      @current_pointer += 4
    when 9
      value = parameter_in_mode(0, modes)
      @relative_base += value

      @current_pointer += 2
    end
  end

  def input_param(parameter_id, modes)
    parameter_id ||= 0
    parameter = @integer_table[@current_pointer + 1 + parameter_id]
    mode = modes[parameter_id] || 0
    case mode
    when 1
      @integer_table[@current_pointer + 1 + parameter_id] || 0
    when 2
      byebug
      @integer_table[@current_pointer + 1 + parameter_id + @relative_base] || 0
    end
  end

  def parameter_in_mode(parameter_id, modes)
    parameter_id ||= 0
    parameter = @integer_table[@current_pointer + 1 + parameter_id]
    mode = modes[parameter_id] || 0
    # byebug
    case mode
    when 0
      # byebugex
      @integer_table[parameter] || 0
    when 1
      parameter || 0
    when 2
      @relative_base + parameter || 0
    end
  end

  def position_value(value, mode)
    case mode
    when 0
      @integer_table[value] || 0
    when 1
      value || 0
    when 2
      @integer_table[@relative_base + value] || 0
    end
    # value = mode.zero? ? @integer_table[value] : value
    # value || 0
  end

  # def ending_symbol_occurred?
  #   @integer_table[@current_round * 4] == ENDING_NUMBER
  # end

  def replace_initial_state
    @integer_table[1] = @noun
    @integer_table[2] = @verb
  end
end

# class Amplifier
#   def initialize(computer, sequence = [[0,1,2,3,4]])
#     @computer_input = computer
#     @sequence = sequence
#     @input = 0
#     @computers = []
#   end

#   def solve
#     @sequence.each do |seq|
#       inputs = [seq, @input]
#       # pp inputs
#       @input = Computer.new(@computer_input).run(inputs: inputs).last
#       # byebug
#     end
#     @input
#   end


#   def solve_2
#     @round = 0
#     @code = :run
#     # @computers =
#     until @round % 5 == 0 && @code == :halt
#       round_id = @round % 5
#       @computers[round_id] = Computer.new(@computer_input) if @computers[round_id].nil?
#       inputs = @round < 5 ? [@sequence[round_id], @input] : [@input]
#       # byebug
#       result = @computers[round_id].run(inputs: inputs)
#       @code = result[:code]
#       @input = result[:output]
#       @round = (@round + 1)
#       # byebug
#       a=5
#     end
#     @input
#     # @sequence.each do |seq|
#     #   # pp inputs
#     #   @input = Computer.new(@computer_input).run(inputs: inputs).last
#     #   # byebug
#     # end
#     # @input
#   end
# end

class Quiz5A
  def initialize(input_filename)
    @input_filename = input_filename
    parse_input(input_filename) if input_filename
    @phase_settings = (0..4).to_a
  end

  def solve
    @computer = Computer.new(@input)
    # @output = @computer.run[:output]
    @input_arr = [1]
    @output = @computer.run(inputs: @input_arr)[:output]
    @output

    # @input_arr = [1]
    # @output = []
    # while @output.count != 1 
    #   # byebug
    #   @output = @computer.run(inputs: @input_arr)[:output]
    #   # byebug
    #   # pp @output
    #   @input_arr = @output
    # end
    # @output




    # res = @phase_settings.permutation.to_a.map do |sequence|
    #   # pp sequence
    #   result = Amplifier.new(parse_input(@input_filename), sequence).solve
    #   # pp result
    #   { "#{sequence}": result }
    # end
    # # pp res
    # res.max { |el, val| el[1] <=> val[1] }
  end

  def parse_input(input_filename)
    @input = File.readlines(input_filename).first
    # map do |line|
      # Computer.new(line)

      # line.strip.split(',').map { |entry| entry.match(/([A-Z])(\d+)/).captures }
      # line.match(/([A-Z])(\d+)/).captures
    # end.first
  end
end

class Quiz5B < Quiz5A
  def initialize(input)
    super(input)
    @phase_settings = (5..9).to_a
  end

  def solve
    res = @phase_settings.permutation.to_a.map do |sequence|
      # pp sequence
      result = Amplifier.new(parse_input(@input_filename), sequence).solve_2
      # pp result
      { "#{sequence}": result }
    end
    # pp res
    res.max { |el, val| el.values.first <=> val.values.first }.values.first
  end
  # def solve
  # end
end

TEST_DATA = [
  ['input-test1.txt', 43210],
  ['input-test2.txt', 54321],
  ['input-test3.txt', 65210],
]

TEST_DATA_2 = [
  ['input-test4.txt', 139629729],
  ['input-test5.txt', 18216],
]

# Test.new(TEST_DATA).test_data do |input|
#   Quiz5A.new(input).solve
# end

# pp Quiz5A.new('input-test1.txt').solve

TEST_DATA.map(&:first).each do |input|
  # pp Quiz5A.new(input).solve
  # byebug
end

pp Quiz5A.new('input.txt').solve


# Test.new(TEST_DATA).test_data do |input|
  # pp Computer.new('', ).get_value(1002)
  # ptrue == true ? pp "true " : pp "else"
  # Quiz5A.new(input).solve
# end

# Test.new(TEST_DATA_2).test_data do |number|
#   Quiz5B.new(input).solve
# end

# byebug

# pp "#{Quiz5A.new('input.txt').solve}"
# pp Quiz5A.new.solve
# pp Quiz5B.new('input.txt').solve
