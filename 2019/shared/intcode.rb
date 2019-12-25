require 'ostruct'

class TapeOperator
  attr_reader :tape, :position

  def initialize(machine_code)
    @tape = machine_code.split(',').each_with_index.map{|input, index| [index, input.to_i] }.to_h
    @position = 0
    @relative_base = 0
  end

  def action
    operation, @args_modes = read_action
    operation
  end

  def write_operation_result(operation_type)
    operation_result = arg_1.send(operation_type, arg_2)
    write(arg_id: 3, value: operation_result)
    move(steps: 4)
  end

  def write_boolean_result
    value = yield == true ? 1 : 0
    write(arg_id: 3, value: value)
    move(steps: 4)
  end

  def conditional_jump
    yield ? move(to: arg_2) : move(steps: 3)
  end

  def modify_relative_base
    @relative_base += arg_1
    move(steps: 2)
  end

  def move(steps: nil, to: nil)
    to ? @position = to : @position += steps
  end

  def arg_1; read_arg(0); end
  def arg_2; read_arg(1); end
  def arg_3; read_arg(2); end

  def read_arg(arg_id)
    arg_base = self[@position + arg_id + 1]
    @args_modes[arg_id] == 2 ? self[arg_base + @relative_base] : common_arg(arg_id, arg_base)
  end

  def write(arg_id:, value:)
    @tape[write_arg(arg_id - 1)] = value
  end

  def write_arg(arg_id)
    arg_base = @position + arg_id + 1
    @args_modes[arg_id] == 2 ? self[arg_base] + @relative_base : common_arg(arg_id, arg_base)
  end

  def common_arg(arg_id, arg_base)
    case @args_modes[arg_id]
    when 0
      self[arg_base]
    when 1
      arg_base
    end
  end

  def []=(index, value)
    @tape[index] = value
  end

  def [](index)
    raise ArgumentError if index < 0
    @tape[index].nil? ? 0 : @tape[index]
  end

  private

  def read_action
    operation_code = @tape[@position].digits
    operation = "#{operation_code[1]}#{operation_code[0]}".to_i
    modes = (2..4).map {|arg_id| operation_code[arg_id].nil? ? 0 : operation_code[arg_id] }

    [operation, modes]
  end
end

class Intcode
  def initialize(code: nil, input: [], filename: nil)
    machine_code = filename ? File.open(filename, &:gets) : code
    @tape_operator = TapeOperator.new(machine_code)
    @input = []
    add_input(input)
    @output = []
  end

  def run
    loop do
      @action_result = perform_action
      break if [:halt, :input_empty].include? @action_result
    end
    OpenStruct.new(code: @action_result, output: output)
  end

  def perform_action
    case @tape_operator.action
    when 1
      @tape_operator.write_operation_result(:+)
    when 2
      @tape_operator.write_operation_result(:*)
    when 3
      return :input_empty if @input.empty?

      @tape_operator.write(arg_id: 1, value: @input.shift)
      @tape_operator.move(steps: 2)
    when 4
      @output << @tape_operator.arg_1
      @tape_operator.move(steps: 2)
    when 5
      @tape_operator.conditional_jump { @tape_operator.arg_1 != 0 }
    when 6
      @tape_operator.conditional_jump { @tape_operator.arg_1 == 0 }
    when 7
      @tape_operator.write_boolean_result { @tape_operator.arg_1 < @tape_operator.arg_2 }
    when 8
      @tape_operator.write_boolean_result { @tape_operator.arg_1 == @tape_operator.arg_2 }
    when 9
      @tape_operator.modify_relative_base
    when 99
      :halt
    end
  end

  def add_input(input)
    @input += input
  end

  def output
    @output
  end
end

class ASCIIConverter
  def self.to_ascii(str)
    "#{str}\n".codepoints.to_a.flatten
  end

  def self.from_ascii(ascii_codes)
    ascii_codes.map do |code|
      begin
        code.chr
      rescue RangeError
        code
      end
    end.join('')
  end
end

module ASCIICoding
  def add_input(input)
    # byebug
    super(input.map {|input_entry| ASCIIConverter.to_ascii(input_entry) }.flatten)
  end

  def output
    ASCIIConverter.from_ascii(@output).split("\n")
  end
end

class ASCIIIntcode < Intcode
  include ASCIICoding
end

class InteractiveACIIIntcode < Intcode
  include ASCIICoding

  def run
    @commands = []
    last_result = super
    until last_result[:code] == :halt
      pp last_result[:output]
      add_input([read_from_console])
      last_result = super
    end
    pp @commands
    last_result
  end

  def read_from_console
    input = gets.chomp
    @commands << input
    input
  end
end
