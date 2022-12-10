module Aoc2022
  module Day10
    class Puzzle10B < Puzzle10
      def solve
        crt_size = 40
        ticks = prepare_ticks(@cmds)
        pic = []

        (ticks.size/crt_size).times do |slice_index|
          crt_size.times do |tick_id|
            if tick_id == 0 && slice_index == 0
              pic << 0
            else
              id = tick_id
              crt_position = ticks[slice_index*40 + tick_id - 1].last
              pic << ((crt_position - 1) <= id && id <= (crt_position + 1))
            end
          end
        end

        pic.each_slice(40) do |slice|
          puts slice.map { |s| s ? '#' : '.' }.join('')
        end
      end
    end
  end
end

