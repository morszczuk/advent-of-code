require_relative '../shared/intcode.rb'
require_relative '../../utils/test.rb'
require 'byebug'
require 'mmap'


class Quiz21A
  def solve(filename)
    results = input.map do |input_pair|
      Intcode.new(filename: filename, input: input_pair).run[:output]
    end.flatten.count(1)
  end

  def input
    50.times.map {|i| 50.times.map {|j| [i,j] }}.flatten(1)
  end
end

# pp Quiz21A.new.solve('input.txt')

class Quiz21B
  def initialize(size, maps_size)
    @size = size
    @maps_size = maps_size
  end

  def find_emitter
    @beam_map = Mmap.new('tmp/beam_map', 'a')
    create_beam_map unless @beam_map.length == @maps_size * @maps_size
    pp "Stworzylem beam map"
    @count_map = create_count_map
    pp "Stworzylem count map"
    closest = @count_map.select {|id, count| count == @size * @size }.min do |val, val2| 
      val = val.first
      val2 = val2.first
      Math.sqrt(val[0] * val[1]) <=> Math.sqrt(val2[0] * val2[1]);
    end
    if closest
      pp "Closest found!!! #{closest}"
      closest = closest.first.reverse
      closest[0] * 10000 + closest[1]
    else
      pp "CLosest unfortunately not found :("
    end
  end

  def create_count_map
    count_map = {}
    count = 0
    @size.times do |x|
      @size.times do |y|
        count += 1 if @beam_map[x * @maps_size + y] == '1'
      end
    end
    count_map[[0,0]] = count
    @maps_size.times do |x|
      @maps_size.times do |y|
        next if x == 0 && y == 0

        count = count_map[[x, y - 1]]
        if count.nil?
          count = count_map[[x - 1, y]]
          @size.times {|new_y| count -= 1 if @beam_map[((x - 1) * @maps_size) + y + new_y] == '1' }
          @size.times {|new_y| count += 1 if @beam_map[((x + @size - 1) * @maps_size) + y + new_y] == '1' }
        else
          @size.times {|new_x| count -= 1 if @beam_map[((x + new_x) * @maps_size) + y - 1] == '1' }
          @size.times {|new_x| count += 1 if @beam_map[((x + new_x) * @maps_size) + y + @size - 1] == '1' }
        end 
        count_map[[x, y]] = count
      end
    end
    count_map

    
  end

  def beam_map_value(x, y)
    @beam_map[x * @maps_size + y]
  end

  def find_pattern(size)
    10000.times do |row|
      10000.times do |col|
        return [row, col] if fully_fits?(row, col, size)
      end
      # byebug
    end

    pp 'DUPA NIE ZNALEZIONO!!!!'
  end

  def fully_fits?(i, j, size)
    size.times.to_a.repeated_permutation(2).all? {|x, y| is_part_of_beam?(x + i, y + j) }
    # check = size.times.to_a.repeated_permutation(2).map {|x, y| is_part_of_beam?(x + i, y + j) }
    # byebug if i == 12 && j == 11
    # size.times.map {|x| size.map { |y| [x, ] }  }
  end

  def create_beam_map
    @maps_size.times do |x|
      @maps_size.times do |y|
        @beam_map << is_part_of_beam?(x, y) unless beam_map_value(x, y)
      end
    end
  end

  def is_part_of_beam?(i, j)
    # ['#', 'O'].include?(TEST_DATA[i]&.chars&.[](j)) ? '1' : '0'

    # @beam_map[[i, j]] ||= ['#', 'O'].include? TEST_DATA[i].chars[j]
    Intcode.new(filename: 'input.txt', input: [i, j]).run[:output].first.to_i.to_s
    # byebug
    
  end

  TEST_DATA = [
#                  1111111112222222222
  #    0123456789  01234567890123456789  
# 0   '#.........  ..............................',
# 1   '.#........  ..............................',
# 2   '..##......  ..............................',
# 3   '...###....  ..............................',
# 4   '....###...  ..............................',
# 5   '.....####.  ..............................',
# 6   '......####  #.............................',
# 7   '......####  ##............................',
# 8   '.......###  ####..........................',
# 9   '........##  ######........................',

# 10  '.........#  ########......................',
# 11  '..........  #########.....................',
# 12  '..........  .##########...................',
# 13  '...........############.................',
# 14  '............############................',
# 15  '.............#############..............',
# 16  '..............##############............',
# 17  '...............###############..........',
# 18  '................###############.........',
      '................#################.......',
      '.................########OOOOOOOOOO.....',
      '..................#######OOOOOOOOOO#....',
      '...................######OOOOOOOOOO###..',
      '....................#####OOOOOOOOOO#####',
      '.....................####OOOOOOOOOO#####',
      '.....................####OOOOOOOOOO#####',
      '......................###OOOOOOOOOO#####',
      '.......................##OOOOOOOOOO#####',
      '........................#OOOOOOOOOO#####',
      '.........................OOOOOOOOOO#####',
      '..........................##############',
      '..........................##############',
      '...........................#############',
      '............................############',
      '.............................###########',
      ]

end

pp Quiz21B.new(100, 10000).find_emitter
# pp Quiz21B.new.find_emitter(100)
