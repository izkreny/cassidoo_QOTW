module Answers
  # - Questions::Issue20260316
  # - Benchmarks::Issue20260316
  #
  module Issue20260316
    # :section: Original answer

    def izkreny_fire_station_coverage_nested_each_with_index_lambdas(city_grid)
      city_grid_cell_legend           = { empty: 0, fire_station: 1, building: 2 }
      city_fire_station_locations     = []
      city_fire_station_coverage_grid = Array.new(city_grid.size) { Array.new(city_grid.size) }

      traverse_city_grid = lambda do |&action|
        city_grid.each_with_index do |street, street_number|
          street.each_with_index do |cell, cell_number|
            action.call(street_number, cell_number, cell)
          end
        end
      end

      distance_between_two_locations = lambda do |location_one, location_two|
        (location_one[:street_number] - location_two[:street_number]).abs +
          (location_one[:cell_number] - location_two[:cell_number]).abs
      end

      distance_to_the_nearest_fire_station_from = lambda do |location|
        city_fire_station_locations.map do |fire_station_location|
          return 0 if fire_station_location == location

          distance_between_two_locations.call(fire_station_location, location)
        end.min
      end

      traverse_city_grid.call do |street_number, cell_number, cell|
        city_fire_station_locations << { street_number:, cell_number: } if cell == city_grid_cell_legend[:fire_station]
      end

      traverse_city_grid.call do |street_number, cell_number|
        city_fire_station_coverage_grid[street_number][cell_number] = distance_to_the_nearest_fire_station_from.call(street_number:, cell_number:)
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
