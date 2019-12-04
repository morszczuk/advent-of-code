require_relative '../../utils/test.rb'
require 'byebug'

TEST_DATA = [
  [111111, true],
  [223450, false],
  [123789, false],
]

TEST_DATA_2 = [
  [112233, true],
  [123444, false],
  [111122, true],
]

class Quiz4A
  def solve
    382_345.upto(843_167).count { |number| potential_password?(number.digits.reverse) }
  end

  def potential_password?(digits)
    digits.uniq != digits && digits.sort == digits
  end
end

class Quiz4B < Quiz4A
  def potential_password?(digits)
    super(digits) &&
      digits.chunk_while {|i, j| i == j }.any? { |chunk| chunk.count == 2 }
  end
end

Test.new(TEST_DATA).test_data do |number|
  Quiz4A.new.potential_password? number.digits.reverse
end

Test.new(TEST_DATA_2).test_data do |number|
  Quiz4B.new.potential_password? number.digits.reverse
end

pp Quiz4A.new.solve
pp Quiz4B.new.solve
