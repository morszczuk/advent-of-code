require_relative '../shared/intcode.rb'
require_relative '../../utils/test.rb'
require 'byebug'

options = []
OPTS = 8

class Quiz25A
  def initialize
    @computer = ASCIIIntcode.new(filename: 'input.txt', input: steps_to_take_stuff)
  end

  def solve
    options = prepare_options
    last_result = @computer.run
    i = 0
    until last_result[:code] == :halt
      option = options[i]
      take_stuff_and_move(option)
      last_result = @computer.run
      drop_stuff(option) unless last_result[:code] == :halt
      i += 1
    end
    pp last_result[:output]
    byebug
  end

  def prepare_options
    inv.size.times.map do |i|
      inv.combination(i + 1).to_a.map { |arr| arr }
    end.flatten(1)
  end

  def drop_stuff(option)
    input = option.map {|thing| "drop #{thing}" }
    @computer.add_input(input)
  end

  def take_stuff_and_move(option)
    input = option.map {|thing| "take #{thing}" }
    input << 'west'
    @computer.add_input(input)
  end

  def steps_to_take_stuff
    [
      'east',
      'take sand',
      'west',
      'south',
      'take ornament',
      'north',
      'west',
      'north', # Hallway
      'take wreath',
      'north', # Corridor
      'north', # Passage
      'take spool of cat6', 
      'south', # Corridor
      'south', # Hallway
      'east', # Engineering
      'take fixed point',
      'west',
      'south',
      'south',
      'south',
      'take candy cane',
      'north',
      'east', # Warp Driven Maintenance
      'east', # Navigation
      'east', # Storage
      'take space law space brochure',
      'south',
      'take fuel cell',
      'south', # Security Checkpoint
      # DROP EVERYTHING
      'drop space law space brochure',
      'drop fixed point',
      'drop candy cane',
      'drop sand',
      'drop ornament',
      'drop fuel cell',
      'drop spool of cat6',
      'drop wreath',
      # 'take spool of cat6',
      # 'take ornament',

    ]
  end

  def inv
    @inv ||= ["space law space brochure",
      "fixed point",
      "candy cane",
      "sand",
      "fuel cell",
      "wreath",
      'spool of cat6',
      'ornament',
    ]
  end
end

Quiz25A.new.solve

input =     [
  'east',
  'take sand',
  'west',
  'south',
  'take ornament',
  'north',
  'west',
  'north', # Hallway
  'take wreath',
  'north', # Corridor
  'north', # Passage
  'take spool of cat6', 
  'south', # Corridor
  'south', # Hallway
  'east', # Engineering
  'take fixed point',
  'west',
  'south',
  'south',
  'south',
  'take candy cane',
  'north',
  'east', # Warp Driven Maintenance
  'east', # Navigation
  'east', # Storage
  'take space law space brochure',
  'south',
  'take fuel cell',
  'south', # Security Checkpoint
  # DROP EVERYTHING
  'drop space law space brochure',
  'drop fixed point',
  'drop candy cane',
  'drop sand',
  'drop ornament',
  'drop fuel cell',
  'drop spool of cat6',
  'drop wreath'
]

# result = InteractiveACIIIntcode.new(filename: 'input.txt', input: input).run


