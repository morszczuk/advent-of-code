require 'byebug'
require_relative '../../utils/test.rb'

class Layout
  attr_reader :layout

  def initialize(filename = nil)
    @layout = filename ? parse_input(filename) : empty_layout
  end

  def grow_new_bugs
    @layout = new_bugs_layout
  end

  def new_bugs_layout
    new_layout = empty_layout
    @layout.each_with_index do |row, row_id|
      row.each_with_index do |current_status, col_id|
        new_layout[row_id][col_id] = identify_new_status(current_status, row_id, col_id)
      end
    end
    new_layout
  end

  def identify_new_status(current_status, row_id, col_id)
    new_status = current_status
    new_status = '0' if current_status == '1' && adjacent_bugs(row_id, col_id) != 1
    new_status = '1' if current_status == '0' && [1, 2].include?(adjacent_bugs(row_id, col_id))
    new_status
  end

  def adjacent_bugs(row_id, col_id)
    count = 0
    count += 1 if row_id > 0 && @layout[row_id - 1]&.[](col_id) == '1'
    count += 1 if @layout[row_id + 1]&.[](col_id) == '1'
    count += 1 if col_id > 0 && @layout[row_id]&.[](col_id - 1) == '1'
    count += 1 if @layout[row_id]&.[](col_id + 1) == '1'
    count
  end

  def parse_input(filename)
    File.readlines(filename).each_with_index.map do |line, row|
      clear_line = line.strip.gsub(/\./, '0').gsub(/\#/, '1').chars
    end
  end

  def empty_layout
    Array.new(5) { Array.new(5) { '0' } }
  end

  def snapshot
    @layout.map {|row| row.join('') }.join('')
  end

  def print
    pp "Level: #{@level}"
    @layout.each do |row|
      pp row.join('').gsub(/0/, '.').gsub(/1/, '#')
    end
    pp ''
  end
end

class BugsLand
  attr_reader :layout

  def initialize(filename)
    @layout = Layout.new(filename)
    @previous_layouts = []
  end

  def first_repetition
    @previous_layouts = [@layout.snapshot.to_i(2)]
    until repetition_occured? do
      @layout.grow_new_bugs
      @previous_layouts << @layout.snapshot.to_i(2)
    end
    @layout.snapshot
  end

  def layout_in_time(count)
    count.times do
      @previous_layouts << @layout.snapshot.to_i(2)
      @layout.grow_new_bugs
    end
    @layout.snapshot
  end

  def repetition_occured?
    @previous_layouts.detect{ |e| @previous_layouts.count(e) > 1 }
  end
end

class MultidimensionalLayout < Layout
  attr_reader :level
  attr_accessor :up, :down
  def initialize(level:, filename: nil, up: nil, down: nil)
    super(filename)
    @level = level
    @up = up
    @down = down
  end

  def set_neighbours(down: nil, up: nil)
    @down = down if down
    @up   = up   if up
  end

  def count_bugs
    snapshot.scan(/1/).count
  end

  def snapshot
    @layout.each_with_index.map {|row, row_id| row_id == 2 ? row[0..1].join('') + row[3..4].join('') : row.join('') }.join('')
  end

  def set_layout(layout)
    @layout = layout
  end

  def adjacent_bugs(row_id, col_id)
    count = 0

    case row_id
    when 0
      case col_id
      when 0
        count += 1 if @up && @up.layout[1][2] == '1'
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @up && @up.layout[2][1] == '1'
      when 1, 2, 3
        count += 1 if @up && @up.layout[1][2] == '1'
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id - 1] == '1'
      when 4
        count += 1 if @up && @up.layout[1][2] == '1'
        count += 1 if @up && @up.layout[2][3] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id - 1] == '1'
      end
    when 1
      case col_id
      when 0
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @up && @up.layout[2][1] == '1'
      when 1, 3
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id - 1] == '1'
      when 2
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += @down.row_bug_count(0) if @down
        count += 1 if @layout[row_id][col_id - 1] == '1'
      when 4
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @up && @up.layout[2][3] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id - 1] == '1'
      end
    when 2
      case col_id
      when 0
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @up && @up.layout[2][1] == '1'
      when 1
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += @down.column_bug_count(0) if @down
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id - 1] == '1'
      when 3
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += @down.column_bug_count(4) if @down
      when 4
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @up && @up.layout[2][3] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id - 1] == '1'
      end
    when 3
      case col_id
      when 0
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @up && @up.layout[2][1] == '1'
      when 1, 3
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id - 1] == '1'
      when 2
        count += @down.row_bug_count(4) if @down
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id - 1] == '1'
      when 4
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @up && @up.layout[2][3] == '1'
        count += 1 if @layout[row_id + 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id - 1] == '1'
      end
    when 4
      case col_id
      when 0
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += 1 if @up && @up.layout[3][2] == '1'
        count += 1 if @up && @up.layout[2][1] == '1'
      when 1, 2, 3
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @layout[row_id][col_id + 1] == '1'
        count += 1 if @up && @up.layout[3][2] == '1'
        count += 1 if @layout[row_id][col_id - 1] == '1'
      when 4
        count += 1 if @layout[row_id - 1][col_id] == '1'
        count += 1 if @up && @up.layout[2][3] == '1'
        count += 1 if @up && @up.layout[3][2] == '1'
        count += 1 if @layout[row_id][col_id - 1] == '1'
      end
    end

    count
  end

  def column_bug_count(col_id)
    count = 0
    5.times do |row_id|
      count += 1 if @layout[row_id][col_id] == '1'
    end
    count
  end

  def row_bug_count(row_id)
    count = 0
    5.times do |col_id|
      count += 1 if @layout[row_id][col_id] == '1'
    end
    count
  end
end

class MultidimensionalBugsLand < BugsLand
  attr_reader :dimension_layouts

  def initialize(filename)
    super(filename)
    @layout = MultidimensionalLayout.new(filename: filename, level: 0)
    @dimension_layouts = { 0 => @layout }
    expand_layouts
  end

  def bugs_after_time(ticks)
    ticks.times do
      spread_bugs
      expand_layouts
    end
    self
  end

  def spread_bugs
    new_layouts = {}
    @dimension_layouts.each { |level, layout| new_layouts[level] = layout.new_bugs_layout }
    @dimension_layouts.each { |level, layout| layout.set_layout(new_layouts[level]) }
  end

  def expand_layouts
    bottom_key = @dimension_layouts.keys.min
    if @dimension_layouts[bottom_key].count_bugs > 0
      @dimension_layouts[bottom_key - 1] = MultidimensionalLayout.new(level: bottom_key - 1, up: @dimension_layouts[bottom_key])
      @dimension_layouts[bottom_key].set_neighbours(down: @dimension_layouts[bottom_key - 1])
    end

    top_key = @dimension_layouts.keys.max
    if @dimension_layouts[top_key].count_bugs > 0
      @dimension_layouts[top_key + 1] = MultidimensionalLayout.new(level: top_key + 1, down: @dimension_layouts[top_key])
      @dimension_layouts[top_key].set_neighbours(up: @dimension_layouts[top_key + 1])
    end
  end

  def count_bugs
    @dimension_layouts.values.sum(&:count_bugs)
  end
end

READ_LAYOUT_TEST_DATA = [
  ['input-test.txt', '0000110010100110010010000']
]

Test.new(READ_LAYOUT_TEST_DATA).test_data do |filename|
  BugsLand.new(filename).layout.snapshot
end

LAYOUT_IN_TIME_TEST_DATA = [
  [['input-test.txt', 1], '1001011110111011101101100']
]

Test.new(LAYOUT_IN_TIME_TEST_DATA).test_data do |test_data|
  BugsLand.new(test_data.first).layout_in_time(test_data.last)
end

FIRST_REPETITION_TEST_DATA = [
  ['input-test.txt', '0000000000000001000001000']
]

Test.new(FIRST_REPETITION_TEST_DATA).test_data do |filename|
  BugsLand.new(filename).first_repetition
end

BIODIVERSITY_TEST_DATA = [['input-test.txt', 2129920]]

Test.new(BIODIVERSITY_TEST_DATA).test_data do |filename|
  BugsLand.new(filename).first_repetition.chars.reverse.join('').to_i(2)
end

MULTIDIMENSION_TEST = [
  [['input-test.txt', 0], 8],
  [['input-test.txt', 1], 27],
  [['input-test.txt', 10], 99]
]

Test.new(MULTIDIMENSION_TEST).test_data do |test_data|
  MultidimensionalBugsLand.new(test_data.first).bugs_after_time(test_data.last).count_bugs
end

MULTIDIMENSION_TEST_2 = [
  [['input-test2.txt', 0], 2],
  [['input-test2.txt', 1], 12],
  [['input-test3.txt', 1], 12],
]

Test.new(MULTIDIMENSION_TEST_2).test_data do |test_data|
  MultidimensionalBugsLand.new(test_data.first).bugs_after_time(test_data.last).count_bugs
end

class Quiz24A
  def solve
    BugsLand.new('input.txt').first_repetition.chars.reverse.join('').to_i(2)
  end
end

class Quiz24B
  def solve
    MultidimensionalBugsLand.new('input.txt').bugs_after_time(200).count_bugs
  end
end

pp Quiz24A.new.solve
pp Quiz24B.new.solve




