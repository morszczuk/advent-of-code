module Aoc2020
  module Day6
    class Group
      attr_reader :filled_forms, :forms_count

      def initialize
        @filled_forms = []
        @forms_count = 0
      end

      def add_forms(forms)
        forms.chars.each do |f|
          @filled_forms << f
        end
        @forms_count += 1
      end

      def uniq_forms_count
        uniq_forms.size
      end

      def uniq_forms
        @filled_forms.uniq
      end

      def all_yes_count
        uniq_forms.select(&method(:every_form_contains_form?)).size
      end

      def every_form_contains_form?(form)
        @filled_forms.count { |f| f == form } == @forms_count
      end
    end

    class Puzzle6 < ::Aoc::PuzzleBase
      def initialize
        @previous_line_empty = true
        @groups = []
        super()
      end

      def solve
        raise 'Not defined'
      end

      def unit_tests
        assert_equal 4, 5
        assert true
      end

      def handle_input_line(line)
        if line.present?
          group = @previous_line_empty ? Group.new : @groups.last
          group.add_forms(line)
          @groups << group if @previous_line_empty
          @previous_line_empty = false
        else
          @previous_line_empty = true
        end
      end
    end
  end
end
