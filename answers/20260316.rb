module Answers
  # - Questions::Issue20260316
  # - Benchmarks::Issue20260316
  #
  module Issue20260316
    # :section: Original answer

    def izkreny_fire_station_coverage_double_each_with_index_lambdas(city_grid)
      city_grid_cells_legend          = { empty: 0, fire_station: 1, building: 2 }
      city_fire_station_locations     = []
      city_fire_station_coverage_grid = Array.new(city_grid.size) { Array.new(city_grid.size) }

      traverse_city_grid = lambda do |&block|
        city_grid.each_with_index do |row, latitude|
          row.each_with_index do |cell, longitude|
            block.call(cell, latitude, longitude)
          end
        end
      end

      distance_to_the_nearest_fire_station_from = lambda do |location|
        city_fire_station_locations.map do |fire_station_location|
          (fire_station_location[:latitude] - location[:latitude]).abs + (fire_station_location[:longitude] - location[:longitude]).abs
        end.min
      end

      traverse_city_grid.call do |cell, latitude, longitude|
        city_fire_station_locations << { latitude:, longitude: } if cell == city_grid_cells_legend[:fire_station]
      end

      traverse_city_grid.call do |_cell, latitude, longitude|
        city_fire_station_coverage_grid[latitude][longitude] = distance_to_the_nearest_fire_station_from.call(latitude:, longitude:)
      end

      city_fire_station_coverage_grid
    end

    # :section: Ruby Users Forum answers
    #
    # Topic [][ruf]
    #
    # [ruf]:
  end
end
