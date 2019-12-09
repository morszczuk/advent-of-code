require_relative '../../utils/test.rb'
require 'byebug'

class OpsCodeParser
  def self.call(ops_code)
    digits = ops_code.digits
    operation = "#{digits[1]}#{digits[0]}".to_i
    modes = (2..4).map { |fd| digits[fd].nil? ? 0 : digits[fd] }

    [operation, modes]
  end
end

class Computer
  ENDING_NUMBER = 99

  def initialize(input)
    @current_pointer = 0
    parse_input(input)
    @output = []
  end

  def run
    loop do
      break if do_round == :halt
    end
# byebug
    @output
  end

  def parse_input(input)
    @integer_table = input.split(',').map(&:to_i)
  end

  def do_round
    operation, modes = OpsCodeParser.call(@integer_table[@current_pointer])

    pp "current pointer #{@current_pointer} value: #{@integer_table[@current_pointer]} Opeation: #{operation}, modes: #{modes}"

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
      pp "OPTCODE 3. Provide input: "
      @integer_table[@integer_table[@current_pointer+1]] = gets.chomp.to_i
      @current_pointer += 2
    when 4
      @output << parameter_in_mode(0, modes)
      pp "Current output: #{@output}"
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

class Quiz5A
  def initialize(input_filename = nil)
    parse_input(input_filename) if input_filename
  end

  def solve
    @computer.run
  end

  def parse_input(input_filename)
    @computer = File.readlines(input_filename).map do |line|
      Computer.new(line)

      # line.strip.split(',').map { |entry| entry.match(/([A-Z])(\d+)/).captures }
      # line.match(/([A-Z])(\d+)/).captures
    end.first
  end
end

class Quiz5B < Quiz5A
  def solve
  end
end

TEST_DATA = [
  # '3,9,8,9,10,9,4,9,99,-1,8',
'3,9,7,9,10,9,4,9,99,-1,8',
'3,3,1108,-1,8,3,4,3,99',
'3,3,1107,-1,8,3,4,3,99'
]

TEST_DATA.each do |input|
  # pp Computer.new(input).result
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

pp "#{Quiz5A.new('input.txt').solve}"
# pp Quiz5A.new.solve
# pp Quiz5B.new('input.txt').solve
