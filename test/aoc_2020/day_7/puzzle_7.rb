module Aoc2020
  module Day7
    class AllPathsCounter
      def initialize(graph, root_node)
        @graph = graph
        @count = {}
        @root_node = root_node
      end

      def call
        recursive_child_count(@root_node, 1) - 1
      end

      def recursive_child_count(node, weight)
        # byebug
        child_sum = @graph.children(node)&.map do |child_node, child_weight|
          # byebug
          recursive_child_count(child_node, child_weight*weight)
        end&.sum

        weight + child_sum.to_i
      end
    end

    class ParentNodesCounter
      def initialize(graph, start_node)
        @graph = graph
        @parents = {}
        @start_node = start_node
      end

      def call
        look_for_parents(@start_node)

        @parents.keys
      end

      def look_for_parents(node)
        parent_nodes = find_parent_nodes(node)
        parent_nodes.each(&method(:set_parent))

        parent_nodes.keys.each(&method(:look_for_parents))
      end

      def find_parent_nodes(start_node)
        @graph.colors.select { |key, value| value.map(&:first).include? start_node }
      end

      def set_parent(key, value)
        @parents[key] = true
      end
    end

    class ColorGraph
      attr_accessor :colors

      def initialize
        @colors = {}
      end

      def add_color(color)
        @colors.merge! color
      end

      def values
        colors.values
      end

      def keys
        colors.keys
      end

      def children(node)
        @colors[node]
      end
    end

    class ColorGraphEntryParser
      def self.call(line)
        raw_rule_target, raw_rule_laws = line.split(' contain ')

        rule_target = raw_rule_target.split(' ')[0, 2].join('_')
        rule_laws = raw_rule_laws.split(', ').map(&method(:parse_rule_law)).compact

        { rule_target.to_sym => rule_laws }

        # [rule_target, rule_laws].to_h
      end

      def self.parse_rule_law(raw_law)
        return nil if raw_law == 'no other bags.'

        parts = raw_law.split(' ')
        quantity = parts[0].to_i
        color_name = parts[1, 2].join('_').to_sym

        [color_name, quantity]
      end
    end
    class Puzzle7 < ::Aoc::PuzzleBase
      attr_reader :graph

      def initialize
        @rules = {}
        @graph = ColorGraph.new
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line)
        graph_entry = ColorGraphEntryParser.call(line)
        @graph.add_color(graph_entry)
      end

      def unit_tests
        assert_equal ({ light_red: [[:bright_white, 1], [:muted_yellow, 2]] }),  ColorGraphEntryParser.call('light red bags contain 1 bright white bag, 2 muted yellow bags.')
        assert_equal ({ dotted_black: [] }), ColorGraphEntryParser.call('dotted black bags contain no other bags.')

        graph_nodes_1 = { parent: [[:child, 1]]}
        graph_nodes_2 = { parent: [[:child, 1]], grandfather: [[:parent, 1]]}
        graph = ColorGraph.new

        graph.colors = graph_nodes_1
        assert_equal [:parent], ParentNodesCounter.new(graph, :child).call

        graph.colors = graph_nodes_2
        assert_equal [:parent, :grandfather], ParentNodesCounter.new(graph, :child).call

        graph_nodes_3 = { root: [[:child_1, 1], [:child_2, 2]], child_1: [[:child_1_1, 2]], child_2: [[:child_2_1, 3]]}
        graph.colors = graph_nodes_3

        assert_equal 8, AllPathsCounter.new(graph, :root).call # 1 + 2 + 1*2 + 2*3 = 11
      end
    end
  end
end
