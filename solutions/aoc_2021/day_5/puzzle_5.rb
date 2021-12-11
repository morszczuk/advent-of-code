module Aoc2021
  module Day5
    class Vector
      def initialize(v_start, v_end)
        @v_start = v_start
        @v_end = v_end
      end

      def points
        x = Range.new(*([@v_start.first, @v_end.first].sort)).to_a
        y = Range.new(*([@v_start.last, @v_end.last].sort)).to_a
        return x.product(y) if straight?

        x = x.reverse if @v_start.first > @v_end.first
        y = y.reverse if @v_start.last > @v_end.last
        x.zip(y)
      end

      def straight?
        @v_start.first == @v_end.first || @v_start.last == @v_end.last
      end
    end

    class Puzzle5 < ::Aoc::PuzzleBase
      def initialize
        @entries = []
      end

      def solve
        vectors = @entries.map(&method(:create_vector))
        vectors = yield(vectors) if block_given?
        count_overlapping_points(vectors)
      end

      def create_vector(entries)
        Vector.new(*entries)
      end

      def handle_input_line(line, *_args)
        @entries << line.split(' -> ').map{ |e| e.split(',').map(&:to_i)}
      end

      def count_overlapping_points(vectors)
        @heatmap = Hash.new(0)
        vectors.each { |v| v.points.each { |p| @heatmap[p] += 1} }
        @heatmap.select { |_k, v| v > 1}.count
      end

      def print_heatmap(heatmap)
        (0..9).each do |y|
          pp (0..9).map { |x| heatmap.key?([x, y]) ? heatmap[[x, y]] : '.' }.join('')
        end
      end

      def unit_tests
      end
    end
  end
end
