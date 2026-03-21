module Answers
  # - Questions::Issue20260316
  # - Benchmarks::Issue20260316
  #
  module Issue20260316
    # :section: Original answer

    def izkreny_fire_station_coverage(city_grid)
      fire_station_locations = []
      city_grid.each_with_index do |row, latitude|
        row.each_with_index do |cell, longitude|
          fire_station_locations << { latitude: latitude, longitude: longitude } if cell == 1
        end
      end

      nearest_fire_station_for = lambda do |location|
        fire_station_locations.map do |fire_station_location|
          (fire_station_location[:latitude] - location[:latitude]).abs +
            (fire_station_location[:longitude] - location[:longitude]).abs
        end.min
      end

      city_fire_station_coverage = Array.new(city_grid.size) { Array.new(city_grid.size) }
      city_grid.each_with_index do |row, latitude|
        row.each_with_index do |_cell, longitude|
          city_fire_station_coverage[latitude][longitude] = nearest_fire_station_for.call(latitude:, longitude:)
        end
      end

      city_fire_station_coverage
    end

    # :section: Ruby Users Forum answers
    #
    # Topic [][ruf]
    #
    # [ruf]:
  end
end
