class Nurmburgring
  attr_accessor :cars, :crossovers, :last_crash_position, :nurburgring
  def initialize
    @nurburgring = {}
    @crossovers  = {}
    @cars        = []
  end

  def self.tor
    @@tor
  end

  def parse_input(filename)
    File.open(filename).each_with_index do |line, index|
      handle_line(line, index)
    end
    @@tor = @nurburgring
  end

  def clean_up_crashed_cars
    @cars.select { |c| c.position == @last_crash_position }.each { |car| car.to_be_deleted = true }
  end
  
  def move(car)
    car.brum_brum
  end

  def sort_out_wrecks
    @cars.delete_if(&:to_be_deleted)
  end

  def update_current_leaderboard
    @cars.sort_by! { |car| [car.position[0], car.position[1]]}
  end

  def crash_occurs?
    positions = @cars.select {|c| c.to_be_deleted != true }.map(&:position)
    return unless positions.uniq.length != positions.length

    @last_crash_position = positions.detect { |e| positions.count(e) > 1 }
    true
  end

  def one_car_left?
    @cars.count == 1
  end

  private

  def handle_line(line, index)
    line.delete("\n").chars.each_with_index do |char, y|
      @nurburgring[[index, y]] = char_to_position(char, index, y) if char != ' '
    end
  end

  def char_to_position(char, x, y)
    case char
    when '-'
      :poziom
    when '|'
      :pion
    when '/'
      :right_curve
    when '\\'
      :left_curve
    when '+'
      @crossovers[[x,y]] = 0
      :crossover
    when '^'
      @cars << Car.new(x, y, :up)
      :pion
    when 'v'
      @cars << Car.new(x, y, :down)
      :pion
    when '>'
      @cars << Car.new(x, y, :right)
      :poziom
    when '<'
      @cars << Car.new(x, y, :left)
      :poziom
    end
  end
end

class Car
  attr_accessor :position, :to_be_deleted

  def initialize(x, y, direction)
    @position = [x, y]
    @direction = direction
    @intersection = 0
    @to_be_deleted = to_be_deleted
  end

  def brum_brum
    @position = new_position
    @direction = new_direction(@position)
  end

  private

  def new_position
    case @direction
    when :up
      [@position[0] - 1, @position[1]]
    when :down
      [@position[0] + 1, @position[1]]
    when :right
      [@position[0], @position[1] + 1]
    when :left
      [@position[0], @position[1] - 1]
    end
  end

  def new_direction(position)
    case Nurmburgring.tor[position]
    when :poziom, :pion
      @direction
    when :right_curve
      Direction.curve(@direction, :right)
    when :left_curve
      Direction.curve(@direction, :left)
    when :crossover
      case @intersection
      when 0
        @intersection += 1
        Direction.turn(@direction, :left)
      when 1
        @intersection = 2
        @direction
      when 2
        @intersection = 0
        Direction.turn(@direction, :right)
      end
    end
  end
end

class Direction
  POSITIONS = [
    :left,
    :up,
    :right,
    :down
  ]

  def self.turn(direction, change)
    index = POSITIONS.index(direction)
    case change
    when :left
      index = index == 0 ? 3 : index - 1
      POSITIONS[index]
    when :right
      POSITIONS[(index + 1) % 4]
    end
  end

  def self.curve(direction, curve_type)
    if curve_type == :right
      return :down  if direction == :left
      return :right if direction == :up
      return :up    if direction == :right
      return :left  if direction == :down
    else
      return :up    if direction == :left
      return :left  if direction == :up
      return :down  if direction == :right
      return :right if direction == :down
    end
  end
end

class Race
  def initialize(filename)
    @nurburgring = Nurmburgring.new
    @nurburgring.parse_input(filename)
  end

  def lets_do_it_with_rules_from_part_one
    while true
      @nurburgring.cars.each do |car|
        @nurburgring.move(car)
         if @nurburgring.crash_occurs?
          ceremony_first_hit
          return
         end
      end
      @nurburgring.update_current_leaderboard
    end
  end

  def lets_do_it_with_rules_from_part_two
    until @nurburgring.one_car_left?
      @nurburgring.cars.each do |car|
        next if car.to_be_deleted

        @nurburgring.move(car)
        @nurburgring.clean_up_crashed_cars if @nurburgring.crash_occurs?
      end
      @nurburgring.update_current_leaderboard
      @nurburgring.sort_out_wrecks
    end

    ceremony_last_man_standing
  end

  private

  def ceremony_last_man_standing
    pp @nurburgring.cars.first.position.reverse
  end

  def ceremony_first_hit
    pp @nurburgring.last_crash_position.reverse
  end
end

race = Race.new('./input.txt')
race.lets_do_it_with_rules_from_part_one

race = Race.new('./input.txt')
race.lets_do_it_with_rules_from_part_two


