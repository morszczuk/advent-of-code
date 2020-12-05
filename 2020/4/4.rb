require_relative '../../utils/test.rb'
require 'byebug'
require 'active_support/core_ext/string'
require 'minitest'

module Assertions
  extend Minitest::Assertions

  class << self
    attr_accessor :assertions
  end

  self.assertions = 0
end
# require 'activesupport/lib/active_support/hash_with_indifferent_access'


# TEST_DATA = [
#   ['', ''],
#   ['', ''],
#   ['', ''],
# ]

# TEST_DATA = [
#   ['', ],
#   ['', ],
#   ['', ],
# ]

# TEST_DATA = [
#   [111111, true],
#   [223450, false],
#   [123789, false],
# ]

# TEST_DATA_2 = [
#   [112233, true],
#   [123444, false],
#   [111122, true],
# ]

# TEST_DATA = [
#   ['input-test1.txt', ],
#   ['input-test2.txt', ],
#   ['input-test3.txt', ],
# ]

# TEST_DATA = [
#   ['input-test1.txt', ''],
#   ['input-test2.txt', ''],
#   ['input-test3.txt', ''],
# ]

# TEST_DATA = [
#   ['1,0,0,0,99', '2,0,0,0,99'],
#   ['2,3,0,3,99', '2,3,0,6,99'],
#   ['2,4,4,5,99,0', '2,4,4,5,99,9801'],
#   ['1,1,1,4,99,5,6,0,99', '30,1,1,4,2,5,6,0,99']
# ]

# TEST_DATA_2 = [
#   ['input-test1.txt', 30],
#   ['input-test2.txt', 610],
#   ['input-test3.txt', 410],
# ]

class BaseValidator
  def initialize(value)
    @value = value
  end

  def self.valid?(value)
    new(value).valid?
  end

  def valid?
    false
  end
end

class ByrValidator < BaseValidator
  def valid?
    @value.size == 4 && @value.to_i > 1919 && @value.to_i < 2003
  end
end

Assertions.assert(ByrValidator.valid?('2000'))
Assertions.refute(ByrValidator.valid?('200'))
Assertions.refute(ByrValidator.valid?('2004'))

class IyrValidator < BaseValidator
  def valid?
    @value.size == 4 && @value.to_i >= 2010 && @value.to_i <= 2020
  end
end

validator = IyrValidator

Assertions.assert(validator.valid?('2010'))
Assertions.assert(validator.valid?('2020'))

Assertions.refute(validator.valid?('2009'))
Assertions.refute(validator.valid?('209'))
Assertions.refute(validator.valid?('2021'))

class EyrValidator < BaseValidator
  def valid?
    @value.size == 4 && @value.to_i >= 2020 && @value.to_i <= 2030
  end
end

class HgtValidator < BaseValidator
  def valid?
    return validate_inches if @value.include?('in')
    return validate_cms if @value.include?('cm')

    false
  end

  def validate_inches
    numerical = @value.to_i

    numerical >= 59 && numerical <= 76
  end

  def validate_cms
    numerical = @value.to_i

    numerical >= 150 && numerical <= 193
  end
end

validator = HgtValidator

Assertions.assert(validator.valid?('60in'))
Assertions.assert(validator.valid?('190cm'))

Assertions.refute(validator.valid?('190in'))
Assertions.refute(validator.valid?('190'))

class HclValidator < BaseValidator
  def valid?
    /#([0-9]|[a-f]){6}/.match? @value
  end
end

validator = HclValidator

Assertions.assert(validator.valid?('#123abc'))

Assertions.refute(validator.valid?('#123abz'))
Assertions.refute(validator.valid?('#12abz'))
Assertions.refute(validator.valid?('123abc'))

class EclValidator < BaseValidator
  def valid?
    %w[amb blu brn gry grn hzl oth].any? { |color| color == @value }
  end
end

validator = EclValidator

Assertions.assert(validator.valid?('brn'))

Assertions.refute(validator.valid?('wat'))

class PidValidator < BaseValidator
  def valid?
    @value.size == 9 && /[0-9]{9}/.match?(@value)
  end
end

validator = PidValidator

Assertions.assert(validator.valid?('000000001'))
Assertions.assert(validator.valid?('000043242'))
Assertions.assert(validator.valid?('350043242'))

Assertions.refute(validator.valid?('0123456789'))


class PassportValidator
  FIELD_VALIDATORS = {
    'byr' => ByrValidator,
    'iyr' => IyrValidator,
    'eyr' => EyrValidator,
    'hgt' => HgtValidator,
    'hcl' => HclValidator,
    'ecl' => EclValidator,
    'pid' => PidValidator
  }

  def initialize(**passport_fields)
    @passport_fields = passport_fields
  end

  def valid?
    result = (required_fields - @passport_fields.keys).empty? ? 1 : 0

    return 0 if result.zero?

    any_key_invalid ? 0 : 1
  end

  def required_fields
    @required_fields = FIELD_VALIDATORS.keys.sort
  end

  def any_key_invalid
    FIELD_VALIDATORS.any? do |field, validator|
      !validator.valid?(@passport_fields[field])
    end
  end
end

class Passport
  attr_accessor :fields

  def initialize
    @fields = {}
  end

  def parse_line_of_fields(line)
    new_fields = line.split(' ').map { |attrs| attrs.split(':') }.to_h

    @fields.merge! new_fields
  end
end

class Quiz4A
  def initialize(input_filename = nil)
    @previous_line_empty = true
    @passports = []
    parse_input(input_filename) if input_filename
  end

  def solve
    @passports.map do |passport|
      PassportValidator.new(**passport.fields).valid?
    end.sum
  end

  def parse_input(input_filename)
    File.readlines(input_filename).each do |line|
      # pp line
      # byebug
      if line.present?
        passport = @previous_line_empty ? Passport.new : @passports.last
        passport.parse_line_of_fields(line)
        @passports << passport if @previous_line_empty
        @previous_line_empty = false
      else
        @previous_line_empty = true
      end
      # line.strip.split(',').map { |entry| entry.match(/([A-Z])(\d+)/).captures }
      # line.match(/([A-Z])(\d+)/).captures
    end
  end
end

class Quiz4B < Quiz4A
  def solve
    @passports.map do |passport|
      PassportValidator.new(**passport.fields).valid?
    end.sum
  end
end

# Test.new(TEST_DATA).test_data do |input|
#   Quiz4A.new.solve input
# end

# Test.new(TEST_DATA_2).test_data do |input|
  # Quiz4B.new.solve input
# end

pp 'Answer'
# pp Quiz4A.new('test.txt').solve
# pp Quiz4A.new.solve
# pp Quiz4B.new('input.txt').solve

# Replace 4


case_3 = {
  'hcl' => ' #ae17e1',
  'iyr' => '2013',
  'eyr' => '2024',
  'ecl' => 'brn',
  'pid' => '760753108',
  'byr' => '1931',
  'hgt' => '179cm'
}



# pp 'cases'
# pp PassportValidator.new(**case_3).valid?


pp 'Invalid'
pp Quiz4B.new('test-2-invalid.txt').solve

pp 'Valid'
pp Quiz4B.new('test-2-valid.txt').solve

pp 'Test 2'
pp Quiz4B.new('input.txt').solve
