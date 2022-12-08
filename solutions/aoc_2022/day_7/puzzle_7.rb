module Aoc2022
  module Day7
    class Node
      attr_accessor :dir, :children, :type, :parent, :size
      def initialize(dir, type, size = nil)
        @dir = dir
        @size = size
        @children = []
        @type = type
        @parent = nil
      end

      def add_child(node)
        @children << node
        node.parent = self
      end

      def calculate_size
        @size ||= (@size || 0) + children.map(&:calculate_size).sum
      end

      def has_node_dir?(dir)
        @children.map(&:dir).include? dir
      end

      def find_node(dir)
        @children.find do |node|
          node.dir == dir
        end
      end

      def to_s
        "#{dir} | #{type} | #{children.count} | #{children.map(&:dir)}"
      end

      def all_children
        dir_children = @children.select { | c| c.type == :dir }
        ([dir_children] + dir_children.map(&:all_children)).flatten
      end
    end

    class Puzzle7 < ::Aoc::PuzzleBase
      def initialize
        @cmds = []
      end

      def solve
        raise 'Not defined'
      end

      def build_graph(cmds)
        copy_cmds = @cmds.dup
        start = Node.new('/', :dir)
        nodes = []
        current_node = start
        # cmds.shift
        until cmds.empty?
          cmd = cmds.shift
          case cmd
          when /\$ cd/
            case cmd
            when /\$ cd \//
              current_node = start
            when /\$ cd \.\./
              # byebug
              current_node = current_node.parent
            else
              # byebug
              # byebug
              dir = cmd.split(' ').last
              # current_node = nodes[current_dir]
              # byebug
              current_node = current_node.find_node(dir)
            end
            # pp current_node
            # pp current_dir
            # byebug
          when /\$ ls/
            until cmds.empty? || cmds.first =~ /\$/
              cmd = cmds.shift
              case cmd
              when /dir/
                # byebug
                dir = cmd.split(' ').last
                # if nodes.find { |n| n.dir == dir }.nil?
                  # nodes << node
                # end
                byebug if current_node.nil?
                unless current_node.has_node_dir? dir
                  # byebug
                  current_node.add_child(Node.new(dir, :dir))
                end
              else
                # byebug
                size, dir = cmd.split(' ')
                size = size.to_i
                node = Node.new(dir, :file, size)
                current_node.add_child(node)
              end
            end
          end
        end
        start
      end

      def handle_input_line(line, *_args)
        @cmds << line
      end

      def unit_tests
      end
    end
  end
end
