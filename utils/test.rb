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
