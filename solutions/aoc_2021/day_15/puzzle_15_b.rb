module Aoc2021
  module Day15
    class Puzzle15B < Puzzle15
      MULTIPLIER = 5
      # 2990 - too high
      # 935 - too low
      def solve
        # @ending = [@map.width - 1, (@map.height - 1)*25]
        @infinity = @map.size * 10
        res = shortest_path_wg(@map.array)
        res.sum
        # prepare_cost_map
      end

      def shortest_path_wg(matrix, init = 0)
        test_map = Aoc::Array2D.new
        (@map.height * MULTIPLIER).times do |i|
          row = [nil] * (@map.width * MULTIPLIER)
          test_map.add_row(row)
        end

        (@map.height * MULTIPLIER).times do |y|
          (@map.width * MULTIPLIER).times do |x|
            test_map.set_value(x, y, field_value(x, y))
          end
        end

        matrix = test_map.array

        byebug

        pp matrix

        vertex = []
        v = matrix[0].length
        dist = []
        prev = []

        v.times do |i|
          dist << @infinity
          prev << -1
          vertex << i
        end

        dist[init] = 0

        while vertex.length > 0

          u = vertex.shift

          matrix[u].each_with_index do |i,j|

            next if i == 0
            alt =  dist[u] + i
            if alt < dist[j]
              dist[j] = alt
              prev[j]  = i
            end

          end
        end

        dist

      end

      def prepare_cost_map
        @cost_map = Aoc::Array2D.new
        (@map.height * MULTIPLIER).times do |i|
          row = [nil] * (@map.width * MULTIPLIER)
          @cost_map.add_row(row)
        end

        test_map = Aoc::Array2D.new
        (@map.height * MULTIPLIER).times do |i|
          row = [nil] * (@map.width * MULTIPLIER)
          test_map.add_row(row)
        end


        # @cost_map.print_array

        @cost_map.height.times do |y|
          @cost_map.width.times do |x|
            test_map.set_value(x, y, field_value(x, y))
          end
        end

        test_map.print_array
        # byebug

        bfs = [[@cost_map.width - 1, @cost_map.height - 1]]
        bfs = [[0, 0]]
        # bfs = []
        visited = []

        while (node_coords = bfs.shift).present?
          # node_val = @map.value(*node_coords)
          next if @cost_map.value(*node_coords).present?
          # pp node_coords
          # if @min_score.present? && @min_score < score + node_val
          #   pp :dead_end
          #   return nil
          # end
          min_val = field_value(*node_coords) + (@cost_map.adjacent_top_left_coords(*node_coords).map { |c| @cost_map.value(*c) }.min || 0)
          # min_val = field_value(*node_coords) + (@cost_map.adjacent_bottom_right_coords(*node_coords).map { |c| @cost_map.value(*c) }.min || 0)
          # pp min_val
          @cost_map.set_value(*node_coords, min_val)
          # visited << node_coords


          # bfs += (@cost_map.adjacent_top_left_coords(*node_coords))
          bfs += (@cost_map.adjacent_bottom_right_coords(*node_coords))
          # bfs += (@cost_map.adjacent_top_left_coords(*node_coords) - visited)
          # .each do |next_node|
          #   # byebug if node_coords == [0,0]
          #   set_cost(cost_map, next_node, @map.value(*node_coords))
          # end



          # score += node_val
          # pp path
          # pp score
          # @bfs += (@map.adjacent_coords(*node_coords) - path).sort_by { |c| @map.value(*c) }
          # pp @bfs
          # byebug
        end

        @cost_map.each_elem do |elem, y, x|
          # byebug
          byebug if (@cost_map.adjacent_bottom_right_coords(x, y).map { |c| @cost_map.value(*c) }.min || 0 ) < (@cost_map.adjacent_top_left_coords(x, y).map { |c| @cost_map.value(*c) }.min || 0)
        end

        # set_cost(@cost_map, ending, 0)
        # @map.print_array
        @cost_map.print_array
        # @cost_map.value(0, 0) - @map.value(0, 0)
        byebug
        @cost_map.value(@cost_map.width - 1, @cost_map.height - 1) - field_value(0, 0)
      end

      def field_value(x, y)
        base_x = x % @map.width
        base_y = y % @map.height

        # pp [x, y]
        # pp [base_x, base_y]

        change_x = x / @map.width
        change_y = y / @map.height

        change = change_x + change_y



        base_value = @map.value(base_x, base_y)

        value = (base_value + change) % 9
        value = 9 if value == 0

        # pp value


        # byebug

        value
      end
    end
  end
end

