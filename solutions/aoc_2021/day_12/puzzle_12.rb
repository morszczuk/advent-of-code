module Aoc2021
  module Day12
    class Graph
      attr_reader :connections
      def initialize
        @connections = Hash.new()
      end

      def add_connection(a, b)
        @connections[a] ||= []
        @connections[a] << b
      end

      def connection_for(a)
        @connections[a]
      end
    end

    class Node
      attr_reader :label

      def initialize(label)
        @label = label
      end

      def start?
        @label == 'start'
      end

      def end?
        @label == 'end'
      end

      def revisitable?
        !start? && !end? && ('A'..'Z').include?(@label.first)
      end
    end

    class PathFinder
      def initialize(graph, nodes)
        @graph = graph
        @nodes = nodes
        @visited = []
        @starting_node = @nodes['start']
        @ending_node = @nodes['end']
      end

      def find_all_paths(allow_visit = false)
        @paths = []
        path = []
        visited = []

        allowed_double_visit = if allow_visit
                                  []
                                else
                                  @nodes.values.reject(&:revisitable?)  - [@starting_node, @ending_node]
                                end
        @allowed_double_visit_starting = allowed_double_visit.clone

        handle_node(@starting_node, path.clone, visited.clone, allowed_double_visit.clone)

        @paths
      end

      def handle_node(node, path, visited, allowed_double_visit)
        return if visited.include?(node)
        return path if node.end?

        path << node

        unless node.revisitable?
          if allowed_double_visit.include?(node)
            allowed_double_visit -= [node]
          else
            if visited.empty?
              visited = @allowed_double_visit_starting - allowed_double_visit - [node]
            end
            allowed_double_visit = []
            visited << node
          end
        end

        (@graph.connection_for(node) - visited - [@starting_node]).each do |node|
          res = handle_node(node, path.clone, visited.clone, allowed_double_visit.clone)
          @paths << res if res
        end
        nil
      end
    end

    class Puzzle12 < ::Aoc::PuzzleBase
      def initialize
        @nodes = {}
        @graph = Graph.new
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        node_a_label, node_b_label = line.split('-')
        node_a = @nodes[node_a_label] || (@nodes[node_a_label] = Node.new(node_a_label))
        node_b = @nodes[node_b_label] || (@nodes[node_b_label] = Node.new(node_b_label))

        @graph.add_connection(node_a, node_b)
        @graph.add_connection(node_b, node_a)
      end

      def unit_tests
      end
    end
  end
end
