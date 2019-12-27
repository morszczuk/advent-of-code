require_relative '../shared/intcode.rb'
require_relative '../../utils/test.rb'
require 'byebug'

class NICRunner
  attr_accessor :computer, :idle_time

  def initialize(id, queues, nat)
    @id = id
    @queues = queues
    @nat = nat
    @idle_time = 0
    @computer = IntcodeWithListeners.new(filename: 'input.txt', input: [id])
    @computer.add_listeners(OutputListener.new(id, @computer, @queues, @nat))
  end

  def run
    result = @computer.run
    @idle_time += 1 if result[:code] == :input_empty && (@queues[@id].nil? || @queues[@id].empty?)
    @idle_time = 0 if (!@queues[@id].nil? && !@queues[@id].empty?)
    puts "[#{@id}]Packet received #{@queues[@id]}" unless (@queues[@id].nil? || @queues[@id].empty?)
    input = (@queues[@id].nil? || @queues[@id].empty?)  ? [-1] : @queues[@id].shift
    @computer.add_input(input)
  end
end

class OutputListener
  def initialize(id, computer, queues, nat)
    @computer = computer
    @id = id
    @status = :awaiting
    @packets = []
    @queues = queues
    @nat = nat
  end

  def notify
    @packets << @computer.output.shift
    if @packets.size == 3 
      id = @packets.shift
      @queues[id] = [] unless @queues[id]
      @queues[id] << @packets
      puts "Packet added: [#{id}]#{@packets}"
      if id == 255
        puts "NAT overwritten!!!!"
        # byebug
        @nat << @packets
        # @nat = [@packets]
      end
      @packets = []
    end
  end
end

@queues = {}
@nat = []
@nat_history = []

@runners = 50.times.map {|i| NICRunner.new(i, @queues, @nat)}

def nat_y_value_delivered_twice?
  return false if @nat_history.empty? || @nat_history.count == @last_remember_count

  @last_remember_count = @nat_history.count
  @nat_history.map(&:last).each_cons(2).find {|pair| pair[0] == pair[1] }

  # byebug
  # @nat_history.map(&:last)
  # byebug
end

# results = @runners.each {|runner| Thread.new { runner.run } }
until pair = nat_y_value_delivered_twice? do
  idle_occurs = @runners.map(&:idle_time).all? { |idle_time| idle_time > 10 }
  if idle_occurs
    # byebug
    @queues[0] = [@nat.last]
    @nat_history << @nat.last
    # byebug
  end
  @runners.each(&:run)
end

pp pair
byebug


# results = @runners.each {|runner| Thread.new { runner.run } }
byebug
a = 5
