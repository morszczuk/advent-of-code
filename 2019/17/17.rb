require_relative '../shared/intcode.rb'
require_relative '../../utils/test.rb'
require 'byebug'

class Scaffold
  def initialize(input)
    @pattern = {}
    parse_input(input)
  end

  def get_path
    @path = []
    @position = robot_position
    @direction = :up
    until all_cleaned_up?
      change_direction
      move_in_current_direction
    end
    @path
  end

  def change_direction    
    %i[left right].each do |turn_direction|
      if @pattern[position_after_movement(turn(turn_direction))] == :block
        @path << turns_code[turn_direction]
        @direction = turn(turn_direction)
      end
    end
  end

  def move_in_current_direction
    movement_count = 0
    until no_movement_in_current_direction?
      movement_count += 1
      @position = position_after_movement(@direction)
    end
    @path << movement_count.to_s
  end

  def no_movement_in_current_direction?
    @pattern[position_after_movement(@direction)] != :block
  end

  def position_after_movement(direction)
    case direction
    when :up
      [@position[0] - 1, @position[1]]
    when :down
      [@position[0] + 1, @position[1]]
    when :left
      [@position[0], @position[1] - 1]
    when :right
      [@position[0], @position[1] + 1]
    end
  end

  def all_cleaned_up?
    @pattern[position_after_movement(@direction)] != :block &&
      @pattern[position_after_movement(turn(:right))] != :block &&
      @pattern[position_after_movement(turn(:left))] != :block
  end

  def turn(turn_direction)
    current_index = turns.index(@direction)
    turn_direction == :right ? turns[(current_index + 1) % 4] : turns[(current_index - 1) % 4]
  end

  def turns
    %i[up right down left]
  end

  def turns_code
    {
      right: 'R',
      left:  'L'
    }
  end

  def robot_position
    @pattern.select {|ids, type| type == :robot }.keys.first
  end

  def intersections
    @pattern.select {|ids, type| type == :block && all_adjacent_block?(*ids) }
  end

  def all_adjacent_block?(row_id, col_id)
    @pattern[[row_id - 1, col_id]] == :block &&
      @pattern[[row_id + 1, col_id]] == :block &&
      @pattern[[row_id, col_id - 1]] == :block &&
      @pattern[[row_id, col_id + 1]] == :block
  end

  def parse_input(input)
    input.each_with_index do |row, row_id|
      row.split('').each_with_index do |elem, col_id|
        @pattern[[row_id, col_id]] = case elem
        when '.'
          :open
        when '#'
          :block
        else
          :robot
        end
      end
    end
  end
end

class Quiz17A
  def solve(filename)
    quiz_input = ASCIIIntcode.new(filename: filename).run[:output]
    Scaffold.new(quiz_input).intersections.keys.map {|array| array.reduce(:*) }.sum
  end
end

class Quiz17B
  def solve(filename)
    input = instructions
    output = ASCIIIntcode.new(filename: filename, input: input).run[:output]
    result = output.pop
    pp output
    result
  end

  def instructions
    [
      'A,B,A,B,C,C,B,A,B,C',
      'L,12,L,10,R,8,L,12',
      'R,8,R,10,R,12',
      'L,10,R,12,R,8',
      'n'
    ]
  end
end

pp Quiz17A.new.solve('input.txt')
pp Quiz17B.new.solve('input2.txt')

############# TEST CASES ######################

SCAFFOLD_1 = 
[
  '..#..........',
  '..#..........',
  '#######...###',
  '#.#...#...#.#',
  '#############',
  '..#...#...#..',
  '..#####...^..'
]

NUMBER_OF_INTERSECTIONS_TEST = [
  [SCAFFOLD_1, 4]
]

Test.new(NUMBER_OF_INTERSECTIONS_TEST).test_data do |input|
  Scaffold.new(input).intersections.count
end

INTERSECTIONS_TEST = [
  [SCAFFOLD_1, [[2, 2], [2, 4], [6, 4], [10, 4]]]
]

Test.new(INTERSECTIONS_TEST).test_data do |input|
  Scaffold.new(input).intersections.keys.map(&:reverse)
end

INTERSECTIONS_SUM_TEST = [
  [SCAFFOLD_1, 76]
]

Test.new(INTERSECTIONS_SUM_TEST).test_data do |input|
  Scaffold.new(input).intersections.keys.map {|array| array.reduce(:*) }.sum
end

PART_2_DATA = [
'#######...#####',
'#.....#...#...#',
'#.....#...#...#',
'......#...#...#',
'......#...###.#',
'......#.....#.#',
'^########...#.#',
'......#.#...#.#',
'......#########',
'........#...#..',
'....#########..',
'....#...#......',
'....#...#......',
'....#...#......',
'....#####......',
]

CLEANUP_TEST = [
  [PART_2_DATA, 'R,8,R,8,R,4,R,4,R,8,L,6,L,2,R,4,R,4,R,8,R,8,R,8,L,6,L,2']
]

Test.new(CLEANUP_TEST).test_data do |input|
  Scaffold.new(input).get_path.join(',')
end

QUIZ_DATA = ["....###########............................",
  "....#.........#............................",
  "....#.........#............................",
  "....#.........#............................",
  "....#.........#............................",
  "....#.........#............................",
  "....#.........#............................",
  "....#.........#............................",
  "....#############..........................",
  "..............#.#..........................",
  "..............#.#..........................",
  "..............#.#..........................",
  "..............###########..................",
  "................#.......#..................",
  "................#.......#..................",
  "................#.......#..................",
  "................###########...############^",
  "........................#.#...#............",
  "........................#.#...#............",
  "........................#.#...#............",
  "........................#.#...#............",
  "........................#.#...#............",
  "........................#.#...#............",
  "........................#.#...#............",
  "................#########.#...#............",
  "................#.........#...#............",
  "....#########...#.....#########............",
  "....#.......#...#.....#...#................",
  "....#.......#.#############................",
  "....#.......#.#.#.....#....................",
  "....#.......#.#.#.....#....................",
  "....#.......#.#.#.....#....................",
  "....#.......#.#.#.....#....................",
  "....#.......#.#.#.....#....................",
  "....#############.....#....................",
  "............#.#.......#....................",
  "#############.#.......#....................",
  "#.............#.......#....................",
  "#.............#########....................",
  "#..........................................",
  "#.#########................................",
  "#.#........................................",
  "#.#........................................",
  "#.#........................................",
  "#.#........................................",
  "#.#........................................",
  "#.#........................................",
  "#.#........................................",
  "###########................................",
  "..#.......#................................",
  "..#.......#................................",
  "..#.......#................................",
  "..###########..............................",
  "..........#.#..............................",
  "..........#.#..............................",
  "..........#.#..............................",
  "..........#############....................",
  "............#.........#....................",
  "............#.........#....................",
  "............#.........#....................",
  "............#.........#....................",
  "............#.........#....................",
  "............#.........#....................",
  "............#.........#....................",
  "............###########...................."]

  pp Scaffold.new(QUIZ_DATA).get_path.join(',')
