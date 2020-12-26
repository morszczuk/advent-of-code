module Aoc2020
  module Day20
    class Puzzle20A < Puzzle20
      def solve
        result, picture_tiles = PictureAlgorithm.new(@tiles).call

        size = picture_tiles.keys.map(&:first).max
        tile_size = picture_tiles.values.first.elements.size

        res = (0..size).map do |row|
          (1..tile_size - 2).map do |image_row|
            (0..size).map do |col|

              elements = picture_tiles[[row, col]].option_image[image_row]
              elements = elements[1..elements.size - 2]
              elements.join('')
            end.join('')
          end.join("\n")
        end

        puts res.join("\n")

        result
      end
    end
  end
end
