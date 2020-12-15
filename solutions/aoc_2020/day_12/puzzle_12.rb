module Aoc2020
  module Day12
    class MovingObject
      attr_reader :position, :angle

      def initialize(starting_position = [0, 0])
        @starting_position = starting_position
        @position = starting_position.deep_dup
        @angle = 0
      end

      def move(position_change: nil, angle_change: nil)
        @position = [@position[0] + position_change[0], @position[1] + position_change[1]] if position_change.present?
        @angle = (@angle + angle_change) % 360  if angle_change.present?
      end
    end

    class CommandTranslator
      ROTATION_MAPPING = {
        'N' => 90,
        'E' => 0,
        'S' => 270,
        'W' => 180
      }

      def self.call(raw_move, base_vector: [0, 0], angle: 0)
        type, value = parse_move(raw_move)

        case type
        when /N|E|S|W/ then move(value, ROTATION_MAPPING[type])
        when /R/, /L/ then rotation(value, type == 'R')
        when /F/ then move(value, angle)
        end
      end

      def self.rotation(value, right_rotation)
        value *= -1 if right_rotation

        { angle_change: value }
      end

      def self.move(value, angle_degree, y_value: 0)
        angle = angle_degree * Math::PI / 180

        x = value * Math.cos(angle).to_i - y_value * Math.sin(angle).to_i
        y = value * Math.sin(angle).to_i + y_value * Math.cos(angle).to_i

        { position_change: [x, y] }
      end

      def self.parse_move(raw_move)
        raw_type, value = raw_move.split('', 2)
        value = value.to_i

        [raw_type, value]
      end
    end

    class ManhattanDistance
      def self.call(position_a, position_b)
        (position_a[0] - position_b[0]).abs + (position_a[1] - position_b[1]).abs
      end
    end

    class Puzzle12 < ::Aoc::PuzzleBase
      def initialize
        super()
      end

      def solve
        raise 'Not defined'
      end

      def handle_input_line(line, *_args)
        move = @move_translator.call(line, angle: @ship.angle)
        @ship.move(**move)
      end

      def unit_tests
        assert_equal ({ position_change: [0, 5] }), CommandTranslator.call('N5')
        assert_equal ({ position_change: [20, 0] }), CommandTranslator.call('E20')
        assert_equal ({ position_change: [0, 20 ]}), CommandTranslator.call('F20', angle: 90)
        assert_equal ({ angle_change: -90 }), CommandTranslator.call('R90')
        assert_equal ({ angle_change: 270 }), CommandTranslator.call('L270')
      end
    end
  end
end
