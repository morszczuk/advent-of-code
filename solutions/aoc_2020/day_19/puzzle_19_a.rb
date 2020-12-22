module Aoc2020
  module Day19
    class Puzzle19A < Puzzle19
      def solve
        regex = RegexBuilder.new(@rules, @terminals).call

        @messages.sum { |m| regex.match?(m) ? 1 : 0 }
      end


      # Traces of my lost fight with CYK Algorithm...
      def solve_2
        grammatic_time = Time.now
        grammatic = Grammatic.new(@rules, @terminals)
        pp "Gramatic bilding: #{Time.now - grammatic_time}"

        found_correct = 'ababababbbaaaaaaababbbbbbbbabbab'

        # res = AlgorithmCYK.new(grammatic, found_correct).call
        # pp res

        # byebug

        # res

        # algorithm_time = Time.now
        # res = AlgorithmCYK.new(grammatic, 'aaaabbaaaabbbbaaaaababba').call
        # pp "Algorithm time: #{Time.now - algorithm_time}"
        # res

        #         bababbabaabaaababbbaabab
        # aaababbbaaabbbaaaaabbbab
        # aabaaaaabbbabaababaaaaab
        # bbaababbbbababbaaaababaa
        # baaaaaaabbaabbbbbaabaaba
        # bbabbaaaaaaabaaaaabbabbb
        # aabbaababababbabbaabbaba
        # ababaaabaabaabbbbaaaabba
        # abaaaaaabbbababbbaaaabba

        sorted = @messages.sort_by(&:size)
        # byebug

        # assert_equal true, AlgorithmCYK.new(grammatic, 'ababbb').call
        # assert_equal true, AlgorithmCYK.new(grammatic, 'abbbab').call
        # assert_equal true, AlgorithmCYK.new(grammatic, 'abbbab').call

        res = sorted.each_with_index.sum do |message, index|
        #   # check = AlgorithmCYK.new(grammatic, message).call
        #   # byebug
        #   # check == true ? 1 : 0

          # puts "\n\n\n"
          # pp message
          # puts "One to go... #{index + 1}"
          ress = AlgorithmCYK.new(grammatic, message).call ? 1 : 0
          pp [message, ress]
          ress
        end

        res

        # pp @rules
        # result
      end
    end
  end
end

# Sa jakies poprawne!!!
# 11 - 453 - bbaaabaaabababbaaabbababaaaabaaabaabbaaabbaababaaaaababababababbbaaaabbabaaabaaaabbaabba
# 10 - 442 - bababbaaabaabbabaaababaaaabbaababaabbaabaabbabbababaabbabaaabaaaaababbabaabaaabb
# 9 - 423 - bbbbbbabababbabbbbaaaaaabaabaaaaaababaaabbbbbbaabbbabbbaaaaaabaa
# 8 - 417 - aabaabbbbaaaabbbaabaabbbbbabaaabbbabbbbaaabbbababababbbbbaabbbbb
# 7 - 388 - aaabbbaabbbaabbababaabbabbbbabaabbaabbaaaabababbabbbbbba
# 6 - 354 - abaaaaaabbaaaababababbabababbabbbbaaabaabbbaabaa
# 5 - 349 - bbbbbababaabbaaaaaaaaaaaabaaaabaabaabaabbaabaaab
# 4 - 342 - baaaaaaabbaababbbbabaabaababbaabbbaaaabaaaababab
# 3-  270 - babbababbbbabbbbaabaaabaabbaabbaabbabaab
# 2 - 237 - bbabbaabbbaaaabaabbaababbbbbabba
# 1 - 217 - ababababbbaaaaaaababbbbbbbbabbab

# W sumie linii: 589
# Rozpoczyna sie na: 136
# Possibly: 454

# Znalezione 11
