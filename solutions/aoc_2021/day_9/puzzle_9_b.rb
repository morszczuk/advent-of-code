module Aoc2021
  module Day9
    class Puzzle9B < Puzzle9
      def solve
        find_basins(find_all_lowpoints).values.tally.values.max(3).reduce(&:*)
      end

      def find_basins(lowpoints)
        basins = {}
        @map = new_map(@heightmap)

        lowpoints.each_with_index do |lowpoint, index|
          lowpoint_coords, lowpoint_val = lowpoint
          basins[lowpoint_coords] = index
          @map.adjacent_coords(*lowpoint_coords).each do |coords|
            verify_point(coords, lowpoint_val, index, basins)
          end
        end

        basins
      end

      def verify_point(coords, previous_val, basin_id, basins)
        return if (val = @map.value(*coords)) == 9

        basins[coords] = basin_id
        (@map.adjacent_coords(*coords) - basins.keys).each do |coords|
          verify_point(coords, val, basin_id, basins)
        end
      end

      def new_map(map_source)
        map =  Aoc::Array2D.new
        map_source.each { |r| map.add_row(r)}
        map
      end
    end
  end
end
