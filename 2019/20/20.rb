require_relative '../../utils/test.rb'
require 'byebug'


# TEST_DATA = [
#   ['input-test1.txt', 23],
#   ['input-test2.txt', 58]
# ]

# TEST_DATA = [
#   ['input-test1.txt', 23]
# ]

TEST_DATA = [
  ['input-test2.txt', 58]
]

TEST_DATA_2 = [
  ['input-test1.txt', 26],
  # ['input-test2.txt', -1],
  # ['input-test3.txt', 396],
]

class Node
  attr_reader :code, :neighbours
  def initialize(row, col)
    @row = row
    @col = col
    @neighbours = []
  end

  def id
    [@row, @col]
  end

  def add_neighbours(neighbours)
    neighbours.each do |neighbour|
      add_neighbour(neighbour)
      neighbour.add_neighbour(self)
    end
  end

  def add_neighbour(neighbour)
    @neighbours << neighbour unless @neighbours.include?(neighbour)
  end

  def to_s
    id.to_s
  end

  def print_neighbours
    @neighbours.map(&:to_s)
  end

  def id_with_neigh
    "[#{@row}, #{@col}]: {{ #{print_neighbours} }}"
  end

  def add_message(mess, position)
    @code = mess
    @position = position
  end

  def is_start?
    @code == 'AA'
  end

  def is_end?
    @code == 'ZZ'
  end

  def gate?
    !@code.nil?
  end
end

class Maze
  attr_reader :maze

  def initialize(filename)
    @maze = Hash.new
    parse_maze(filename)
  end

  def parse_maze(filename)
    @maze_input = File.readlines(filename).map {|line| donut_line = line.chars; donut_line.pop; donut_line }
    @height, @width, @circle_height_start, @circle_width = establish_donut_size
    create_nodes_for_inside_of_donut
    add_portals
  end

  def establish_donut_size
    height = @maze_input.count - 4
    width = @maze_input.first.count - 4
    circle_height_start = @maze_input.find_index { |line| /(#|\.)+([A-Z]|\ )+(#|\.)+/.match?(line.join('').strip) } - 2
    circle_width = @maze_input[circle_height_start + 2].join('').match(/((#|\.)+)([A-Z]|\ )+(#|\.)+/).captures.first.length + 1
    [height, width, circle_height_start, circle_width]
  end

  def create_nodes_for_inside_of_donut
    (2..(2 + @height - 1)).each do |i|
      if line_inside_donut?(i)
        pp "Line with middle of donut: #{@maze_input[i].join('')}"
        proceed_half_line(i)
      else
        
        pp "Line with full of donut: #{@maze_input[i].join('')}"
        proceed_full_line(i)
      end
    end
  end

  def proceed_half_line(row)
    (2..(2 + @circle_width - 2)).each do |col|
      create_node(row, col)
    end

    ((@width + 3 - @circle_width)..(@width + 1)).each do |col|
      create_node(row, col)
    end
  end

  def proceed_full_line(row)
    (2..(2 + @width - 1)).each do |col|
      create_node(row, col)
    end
  end

  def create_node(row, col)
    current_elem = @maze_input[row][col]
    if current_elem == '.'
      node = Node.new(row - 2, col - 2)
      existing_neighbours = [[row - 3, col - 2], [row - 2, col - 3]].map {|id| @maze[id] }.reject(&:nil?)
      # byebug unless existing_neighbours.empty?
      node.add_neighbours(existing_neighbours) unless existing_neighbours.empty?

      @maze[[row - 2, col - 2]] = node
    end
  end

  def line_inside_donut?(i)
    i >= 2 + @circle_height_start && i < 2 + @height - @circle_height_start
  end

  def add_portals
    read_to_bottom
    read_up
    read_left
    read_right
    @maze.values.reject{|node| node.code.nil? || node.is_start? || node.is_end? }.group_by(&:code).each do |_code, nodes|
      nodes.first.add_neighbours([nodes[1]])
      # byebug
      # group.first
    end
  end

  def read_to_bottom
    [0, @height + 2 - @circle_height_start - 2].each_with_index do |line_id, index|
      # pp @maze_input[line_id].join('')
      up_portal_ids = @maze_input[line_id].each_index.select{|i| ![' ', '.', '#'].include?(@maze_input[line_id][i]) &&  @maze_input[line_id + 1][i] != ' ' }
      up_portal_ids.each do |portal_id|
        mess = "#{@maze_input[line_id][portal_id]}#{@maze_input[line_id + 1][portal_id]}"
        # byebug
        @maze[[line_id, portal_id - 2]].add_message(mess, outer_inner[index])
      end
      # byebug
    end
  end

  def read_up
    [3 + @circle_height_start , @height + 4 - 1].each_with_index do |line_id, index|
      # pp @maze_input[line_id].join('')
      up_portal_ids = @maze_input[line_id].each_index.select{|i| ![' ', '.', '#'].include?(@maze_input[line_id][i]) &&  @maze_input[line_id - 1][i] != ' ' }
      up_portal_ids.each do |portal_id|
        mess = "#{@maze_input[line_id - 1][portal_id]}#{@maze_input[line_id][portal_id]}"
        # byebug
        @maze[[line_id - 4, portal_id - 2]].add_message(mess, inner_outer[index])
      end
      # byebug
    end
  end

  def read_left
    (2..(2+@width - 1)).each_with_index do |line_id, index|
      pp @maze_input[line_id].join('')
      # byebug
      up_portal_ids = @maze_input[line_id].each_index.select{|i| ![' ', '.', '#'].include?(@maze_input[line_id][i]) && ![' ', '.', '#'].include?(@maze_input[line_id][i + 1]) && @maze_input[line_id][i + 2] == '.' }
      up_portal_ids.each do |portal_id|
        mess = "#{@maze_input[line_id][portal_id]}#{@maze_input[line_id][portal_id + 1]}"
        # byebug
        @maze[[line_id - 2, portal_id]].add_message(mess, outer_inner[index])
      end
    end
  end

  def read_right
    (2..(2+@width - 1)).each_with_index do |line_id, index|
      pp @maze_input[line_id].join('')
      up_portal_ids = @maze_input[line_id].each_index.select{|i| ![' ', '.', '#'].include?(@maze_input[line_id][i]) && ![' ', '.', '#'].include?(@maze_input[line_id][i - 1]) && @maze_input[line_id][i - 2] == '.' }
      up_portal_ids.each do |portal_id|
        mess = "#{@maze_input[line_id][portal_id-1]}#{@maze_input[line_id][portal_id]}"
        @maze[[line_id - 2, portal_id - 4]].add_message(mess, inner_outer[index])
      end
    end
  end

  def outer_inner
    [:outer, :inner]
  end

  def inner_outer
    outer_inner.reverse
  end
end

class SolutionNode
  attr_reader :steps, :current_node, :history, :level_deep

  def initialize(current_node, previous_node = nil, steps = 0, history = [], level_deep = 0)
    @current_node = current_node
    @previous_node = previous_node
    @steps = steps
    @history = history
    @level_deep = level_deep
  end

  def algorithm_step
    # next_moves = select_next_moves
    # pp "#{self} : step: #{@current_node.id}. history: #{@history.map(&:id)}" if next_moves.first.nil?
    # byebug if @current_node.code == 'AA'
    next_node = next_moves.first
    @previous_node = @current_node
    @history << @current_node.dup
    @current_node = next_node
    # byebug
    
    @steps += 1

    # next_moves
  end

  def next_moves
    possible_nodes = @current_node.neighbours
    possible_nodes = possible_nodes.reject {|n| n.id == @previous_node.id } unless @previous_node.nil?
    possible_nodes
  end

  def copy_for(next_move)
    SolutionNode.new(next_move, @current_node, @steps + 1, @history.dup, @level_deep)
  end
end

class Algorithm
  def initialize(maze, level_matters = false)
    @maze = maze
    @start_node = @maze.maze.values.find(&:is_start?)
    @end_node = @maze.maze.values.find(&:is_end?)
    @solution_nodes = [SolutionNode.new(@start_node)]
    @level_matters = level_matters
    @level = 0
  end

  def find_shortest_path
    until end_found? do
      # sleep 0.01
      solutions_to_add = []
      @solution_nodes.each do |s_n|
        next_moves = s_n.next_moves
        # byebug if next_moves.count == 0
        until next_moves.count <= 1 do
          next_move = next_moves.pop
          solutions_to_add << s_n.copy_for(next_move)
          
        end
        # @solution_node.move(next_moves.first)
      end
      @solution_nodes.each(&:algorithm_step)
      @solution_nodes = @solution_nodes + solutions_to_add
      if @level_matters
        # @solution_nodes = 
        reject_from_not_level
      else
        @solution_nodes.reject! { |s_n| (s_n.next_moves.empty? || s_n.current_node.is_start?) && !s_n.current_node.is_end? }
      end
    end
    # byebug
    @solution_nodes.find { |n| n.current_node.is_end? }.steps
  end

  def end_found?
    @solution_nodes.any? { |n| n.current_node.is_end? }
  end

  def reject_from_not_level
    @solution_nodes.reject! do |s_n|
      (s_n.next_moves.empty? || s_n.current_node.is_start?) ||
      (@level == 0 && s_n.current_node.gate? && s_n.current_node.position == :outer) ||
      (@level != 0 && s_n.current_node.is_end?)
    end
  end
end

class Quiz20A
  def initialize(input_filename = nil)
    # parse_input(input_filename) if input_filename
    @input = input_filename
  end

  def solve
    maze = Maze.new(@input)
    Algorithm.new(maze, true).find_shortest_path
  end

  def parse_input(input_filename)
    File.readlines(input_filename).each do |line|
      # line.strip.split(',').map { |entry| entry.match(/([A-Z])(\d+)/).captures }
      # line.match(/([A-Z])(\d+)/).captures
    end
  end
end

class Quiz20B < Quiz20A
  def solve
    maze = Maze.new(@input)
    Algorithm.new(maze).find_shortest_path
  end
end

# Test.new(TEST_DATA).test_data do |input|
#   Quiz20A.new(input).solve
# end

Test.new(TEST_DATA_2).test_data do |input|
  Quiz20B.new(input).solve
end

# pp Quiz20A.new('input.txt').solve
# pp Quiz20A.new.solve
# pp Quiz20B.new('input.txt').solve

# Replace 20
