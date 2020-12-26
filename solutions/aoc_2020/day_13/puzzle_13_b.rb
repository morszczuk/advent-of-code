module Aoc2020
  module Day13
    class Puzzle13B < Puzzle13
      def solve
        n_1 = @buses[0][0]
        a_1 = (@buses[0][0] - @buses[0][1]) % @buses[0][0]
        final_result = @buses[1..(@buses.size - 1)].inject([a_1, n_1, 0]) do |result, element|
          a_1, n_1 = result

          n_2 = element[0]
          a_2 = (element[0] - element[1]) % element[0]

          m_1, m_2 = extended_gcd(n_1, n_2)
          res = a_1 * m_2 * n_2 + a_2 * m_1 * n_1
          res = res % (n_1 * n_2)

          [res, n_1 * n_2]
        end

        final_result[0]
      end

      def extended_gcd(a, b)
        # trivial case first: gcd(a, 0) == 1*a + 0*0
        return 1, 0 if b == 0

        # recurse: a = q*b + r
        q, r = a.divmod b
        s, t = extended_gcd(b, r)

        # compute and return coefficients:
        # gcd(a, b) == gcd(b, r) == s*b + t*r == s*b + t*(a - q*b)
        return t, s - q * t
      end
    end
  end
end
