module Aoc2021
  module Day15
    class Puzzle15A < Puzzle15
      def solve
        # @map.print_array
        @starting = [0, 0]
        @ending = [@map.width - 1, @map.height - 1]
        # pp @starting
        # pp @ending

        find_shortest
      end

      def find_shortest
        # @paths = []
        path = []
        score = 0
        @min_score = nil
        # visited = []

        # allowed_double_visit = if allow_visit
        #                           []
        #                         else
        #                           @nodes.values.reject(&:revisitable?)  - [@starting_node, @ending_node]
        #                         end
        # @allowed_double_visit_starting = allowed_double_visit.clone

        # res = find_path(@starting, path.clone, score, true)
        @bfs = [@starting]
        # res = find_path_bfs(path.clone, score)

        # pp res
        # pp @min_score

        # res = find_path(@starting, path.clone, score, false)

        cost_map = prepare_cost_map(@ending)

        # pp res
        # pp @min_score

        # @min_score - @map.value(*@starting)
      end

      def find_path_bfs(path, score)
        while (node_coords = @bfs.shift).present?
          pp node_coords
          node_val = @map.value(*node_coords)
          if @min_score.present? && @min_score < score + node_val
            pp :dead_end
            return nil
          end
          path << node_coords
          score += node_val
          pp path
          pp score
          @bfs += (@map.adjacent_coords(*node_coords) - path).sort_by { |c| @map.value(*c) }
          pp @bfs
          byebug
        end
      end

      def prepare_cost_map(ending)
        @cost_map = Aoc::Array2D.new
        (@map.height).times do |i|
          row = [nil] * (@map.width)
          @cost_map.add_row(row)
        end

        bfs = [[@cost_map.width - 1, @cost_map.height - 1]]

        @cost_map.print_array

        visited = []

        while (node_coords = bfs.shift).present?
          node_val = @map.value(*node_coords)
          next if @cost_map.value(*node_coords).present?
          # pp node_coords
          # if @min_score.present? && @min_score < score + node_val
          #   pp :dead_end
          #   return nil
          # end
          min_val = @map.value(*node_coords) + (@map.adjacent_bottom_right_coords(*node_coords).map { |c| @cost_map.value(*c) }.min || 0)
          # pp min_val
          @cost_map.set_value(*node_coords, min_val)
          visited << node_coords


          bfs += (@map.adjacent_top_left_coords(*node_coords) - visited)
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

        # set_cost(@cost_map, ending, 0)
        # @map.print_array
        @cost_map.value(0, 0) - @map.value(0, 0)
      end

      def set_cost(cost_map, node_coords, cost)
        pp node_coords
        byebug
        min_val = @map.value(*node_coords) + (@map.adjacent_bottom_right_coords(*node_coords).map { |c| cost_map.value(*c) }.min || 0)

        cost_map.set_value(*node_coords, min_val)
        @map.adjacent_top_left_coords(*node_coords).each do |next_node|
          # byebug if node_coords == [0,0]
          set_cost(cost_map, next_node, @map.value(*node_coords))
        end
      end

      def find_path(node_coords, path, score, initial = false)
        if initial && @min_score.present?
          # pp initial && @min_score.present?
          # byebug
          return nil
        end

        node_val = @map.value(*node_coords)
        if @min_score.present? && @min_score < score + node_val
          # pp :dead_end
          return nil
        end

        if node_coords == @ending
          if @min_score.blank? || @min_score > score + node_val
            # pp path
            pp score
            @min_score = score + node_val
            # byebug
            return path
          else
            return nil
          end
        end


        # path << node_coords
        score += node_val

        # pp path
        # pp score

        # (@map.adjacent_bottom_right_coords(*node_coords) - path).sort_by { |c| @map.value(*c) }.each do |next_node|
        @map.adjacent_bottom_right_coords(*node_coords).sort_by { |c| @map.value(*c) }.each do |next_node|
          # byebug if node_coords == [0,0]
          find_path(next_node, path.clone, score.clone, initial)
        end


        # unless node.revisitable?
        #   if allowed_double_visit.include?(node)
        #     allowed_double_visit -= [node]
        #   else
        #     if visited.empty?
        #       visited = @allowed_double_visit_starting - allowed_double_visit - [node]
        #     end
        #     allowed_double_visit = []
        #     visited << node
        #   end
        # end

        # (@graph.connection_for(node) - visited - [@starting_node]).each do |node|
        #   res = handle_node(node, path.clone, visited.clone, allowed_double_visit.clone)
        #   @paths << res if res
        # end
        # nil
      end
    end
  end
end

