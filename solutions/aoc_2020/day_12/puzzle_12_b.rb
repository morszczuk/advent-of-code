module Aoc2020
  module Day12
    class Puzzle12B < Puzzle12
      def initialize
        @move_translator = CommandTranslator
        @ship = MovingObject.new([0, 0])
        @waypoint = MovingObject.new([10, 1])

        super()
      end

      def solve
        ManhattanDistance.call([0, 0], @ship.position)
      end

      def handle_input_line(line, *_args)
        move_to_make = @move_translator.call(line, angle: @ship.angle)

        case line
        when /N|E|S|W/
          @waypoint.move(**move_to_make)
        when /R/, /L/
          waypoint_vector = [@waypoint.position[0] - @ship.position[0], @waypoint.position[1] - @ship.position[1]]
          result_vector = rotate_vector(waypoint_vector, move_to_make[:angle_change] % 360)

          @waypoint.position = [@ship.position[0] + result_vector[0], @ship.position[1] + result_vector[1]]
        when /F/
          waypoint_vector = [@waypoint.position[0] - @ship.position[0], @waypoint.position[1] - @ship.position[1]]
          position_change = [waypoint_vector[0]*move_to_make[:position_change][0], waypoint_vector[1]*move_to_make[:position_change][0]]

          @ship.move(position_change: position_change)
          @waypoint.move(position_change: position_change)
        end
      end

      def rotate_vector(vector, angle_degree)
        angle = angle_degree * Math::PI / 180

        x = vector[0] * Math.cos(angle).to_i - vector[1] * Math.sin(angle).to_i
        y = vector[0] * Math.sin(angle).to_i + vector[1] * Math.cos(angle).to_i

        [x, y]
      end
    end
  end
end
