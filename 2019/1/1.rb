TEST_DATA = [
  [12, 2],
  [14, 2],
  [1969, 654],
  [100756, 33583]
]

TEST_DATA_2 = [
  [14, 2],
  [1969, 966],
  [100756, 50346]
]

class Test
  def initialize(test_data)
    @test_data = test_data
  end

  def test_data
    @test_data.each do |input, expected_result|
      calculated_result = yield(input)
      if calculated_result == expected_result
        pp "Correct for #{input} - #{calculated_result}"
      else
        pp "Incorrect for #{input}. Was #{calculated_result}, should be #{expected_result}"
      end
    end
  end
end

class Fuel
  def initialize(initial_mass)
    @mass = initial_mass
    @substeps = []
  end

  def calculate_total_mass
    while @mass > 0
      @mass = calculate_mass(@mass)
      @substeps << @mass.dup unless @mass <= 0
    end

    @substeps.sum
  end

  def calculate_mass(space_module = nil)
    space_module ||= @mass
    space_module /=3
    space_module - 2
  end
end

class Quiz
  def self.solve
    result = File.open('input.txt').each_with_index.map do |line, index|
      solve_line(line)
    end
    result.sum
  end
end

class Quiz1A < Quiz
  def self.solve_line(line)
    Fuel.new(line.to_i).calculate_mass
  end
end

class Quiz1B < Quiz
  def self.solve_line(line)
    Fuel.new(line.to_i).calculate_total_mass
  end
end

Test.new(TEST_DATA).test_data do |input|
  Fuel.new(input).calculate_mass
end

Test.new(TEST_DATA_2).test_data do |input|
  Fuel.new(input).calculate_total_mass
end

pp "Quiz 1A result: #{Quiz1A.solve}"
pp "Quiz 1B result: #{Quiz1B.solve}"
