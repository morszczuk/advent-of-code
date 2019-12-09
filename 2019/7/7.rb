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
  end

  def run(inputs: [])
    @inputs = inputs
    loop do
      @code_break = do_round
      break if @code_break == :halt || do_round == :input_empty
    end
# byebug
    OpenStruct.new(code: @code_break, output: @output.last)
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

    # pp "current pointer #{@current_pointer} value: #{@integer_table[@current_pointer]} Opeation: #{operation}, modes: #{modes}"

    return :halt if operation == ENDING_NUMBER

    case operation
    when 1, 2
      source = [@integer_table[@current_pointer+1], @integer_table[@current_pointer+2]]
      byebug if modes[2] == 1
      destination = @integer_table[@current_pointer+3]
      source = [0, 1].map { |i|  position_value(source[i], modes[i]) }
      value = operation == 1 ? source.sum : source.inject(:*)

      @integer_table[destination] = value
      @current_pointer += 4
    when 3
      # pp "OPTCODE 3. Provided input: #{@inputs.first}"
      if @inputs.empty?
        return :input_empty
        # @stopped = true

        # @inputs.empty?
      end
      # && @output.empty?
      input_value = @inputs.shift
      # || @output.shift
      @integer_table[@integer_table[@current_pointer+1]] = input_value
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
    end
  end

  def parameter_in_mode(parameter_id, modes)
    parameter = @integer_table[@current_pointer + 1 + parameter_id]
    modes[parameter_id].zero? ? @integer_table[parameter] : parameter
  end

  def position_value(value, mode)
    mode.zero? ? @integer_table[value] : value
  end

  # def ending_symbol_occurred?
  #   @integer_table[@current_round * 4] == ENDING_NUMBER
  # end

  def replace_initial_state
    @integer_table[1] = @noun
    @integer_table[2] = @verb
  end
end

class Amplifier
  def initialize(computer, sequence = [[0,1,2,3,4]])
    @computer_input = computer
    @sequence = sequence
    @input = 0
    @computers = []
  end

  def solve
    @sequence.each do |seq|
      inputs = [seq, @input]
      # pp inputs
      @input = Computer.new(@computer_input).run(inputs: inputs).last
      # byebug
    end
    @input
  end


  def solve_2
    @round = 0
    @code = :run
    # @computers =
    until @round % 5 == 0 && @code == :halt
      round_id = @round % 5
      @computers[round_id] = Computer.new(@computer_input) if @computers[round_id].nil?
      inputs = @round < 5 ? [@sequence[round_id], @input] : [@input]
      # byebug
      result = @computers[round_id].run(inputs: inputs)
      @code = result[:code]
      @input = result[:output]
      @round = (@round + 1)
      # byebug
      a=5
    end
    @input
    # @sequence.each do |seq|
    #   # pp inputs
    #   @input = Computer.new(@computer_input).run(inputs: inputs).last
    #   # byebug
    # end
    # @input
  end
end

class Quiz5A
  def initialize(input_filename)
    @input_filename = input_filename
    parse_input(input_filename) if input_filename
    @phase_settings = (0..4).to_a
  end

  def solve
    res = @phase_settings.permutation.to_a.map do |sequence|
      # pp sequence
      result = Amplifier.new(parse_input(@input_filename), sequence).solve
      # pp result
      { "#{sequence}": result }
    end
    # pp res
    res.max { |el, val| el[1] <=> val[1] }
  end

  def parse_input(input_filename)
    File.readlines(input_filename).first
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

Test.new(TEST_DATA_2).test_data do |input|
  Quiz5B.new(input).solve
end


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
pp Quiz5B.new('input.txt').solve
