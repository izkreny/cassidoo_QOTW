module Answers
  # - Questions::Issue20260316
  # - Benchmarks::Issue20260316
  #
  module Issue20260316
    # :section: Original answer

    def izkreny_fire_station_coverage_nested_each_with_index_lambdas(city_grid)
      city_grid_cell_legend           = { empty: 0, fire_station: 1, building: 2 }
      city_fire_station_locations     = []
      city_fire_station_coverage_grid = Array.new(city_grid.size) { Array.new(city_grid.first.size) }

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
    # Topic [Cassidoo’s Interview question of the week | 448][ruf]
    #
    # [ruf]: https://www.rubyforum.org/t/cassidoo-s-interview-question-of-the-week-448/198

    def fpsvogel_fire_station_coverage_each_with_index(grid)
      fire_station_coordinates = []
      grid.each.with_index do |cols, row_i|
        cols.each.with_index do |col, col_i|
          fire_station_coordinates << [row_i, col_i] if col == 1
        end
      end

      grid.map.with_index { |cols, row_i|
        cols.map.with_index { |col, col_i|
          fire_station_coordinates.map { |station_row_i, station_col_i|
            (station_row_i - row_i).abs + (station_col_i - col_i).abs
          }.min
        }
      }
    end

    # NOTE: This solution mutate original `city` argument
    #
    def lpogic_fire_station_coverage_filter_map(city)
      squares = (0...city.size).to_a.product((0...city.first.size).to_a)
      fire_stations = squares.filter { |x, y| city[x][y] == 1 }
      squares.each do |x, y|
        city[x][y] = fire_stations.map do |fx, fy|
          (fx - x).abs + (fy - y).abs
        end.min
      end
      city
    end
  end
end
