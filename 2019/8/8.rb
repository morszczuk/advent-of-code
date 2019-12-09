require_relative '../../utils/test.rb'
require 'byebug'

LAYER_SIZE = [25, 6]

class Layer
  attr_reader :data
  def initialize(line, layer_size:)
    @size = layer_size
    @data = line.scan(/.{#{@size[0]}}/).map do |layer_line|
      layer_line.chars.map(&:to_i)
    end
    # pp @data
  end

  def count_of_pixel(pixel)
    @data.flatten.count(pixel) || 0
  end
end

class Image
  def initialize(input, size = [])
    @layers = []
    @size = size
    input.scan(/.{#{@size[0]*@size[1]}}/).each do |layer|
      @layers << Layer.new(layer, layer_size: @size)
          # byebug
    end
  end

  def final_image
    layer_data = @layers.map { |layer| layer.data.flatten }
    result = []
    (@size[0]*@size[1]).times do |i|
      result << decide_pixel(layer_data, i)
    end
    result.map {|pixel| pixel == 0 ? ' ' : 'H'}.each_slice(@size[0]).to_a
    # scan(/.{#{@size[0]}}/).map do |layer_line|
    #   layer_line.chars.map(&:to_i)
    # end
    # @layers.first.data
  end

  def decide_pixel(layer_data, i)
    pixels = layer_data.map { |la| la[i] }.flatten
    until !pixels.first.nil? && pixels.first != 2
      pixels.shift
    end
    pixels.first || 0
  end
end


class Quiz8A
  def initialize(input_filename = nil, size = [])
    @size = size
    @layers = []
    parse_input(input_filename) if input_filename
  end

  def solve
    layer_min = @layers.min {|one, two| one.count_of_pixel(0) <=> two.count_of_pixel(0) }
    # pp layer_min
    # byebug
    layer_min.count_of_pixel(1) * layer_min.count_of_pixel(2)
  end

  def parse_input(input_filename)
    File.readlines(input_filename).each do |line|
      unless line.empty?
        line.strip.scan(/.{#{@size[0]*@size[1]}}/).each do |layer|
        @layers << Layer.new(layer, layer_size: @size)
          # byebug
        end
      end
      # line.strip.split(',').map { |entry| entry.match(/([A-Z])(\d+)/).captures }
      # line.match(/([A-Z])(\d+)/).captures
    end
  end
end

class Quiz8B < Quiz8A
  def parse_input(input)
    File.readlines(input).each do |line|
      unless line.empty?
        @image = Image.new(line.strip, @size)
      end
    end
  end

  def solve
    @image.final_image
  end
end

TEST_DATA = [['test-input1.txt', 1]]
TEST_DATA_2 = [['test-input2.txt', [[0,1], [1,0]]]]



# Test.new(TEST_DATA).test_data do |input|
#   Quiz8A.new(input, [3, 2]).solve
# end

# pp Quiz8A.new('input.txt', LAYER_SIZE).solve

# Test.new(TEST_DATA_2).test_data do |input|
#   Quiz8B.new(input, [2, 2]).solve
# end

Quiz8B.new('input.txt', LAYER_SIZE).solve.each do |line|
  pp line.join('')
end
