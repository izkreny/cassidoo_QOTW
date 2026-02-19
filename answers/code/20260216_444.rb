require_relative "../../test_helper"

# ## Answers
#
# ### Original
module ZoomifyArray
  def zoom_in_by(factor)
    raise ArgumentError, "Factor MUST be an Integer greater than or equal to 2!" unless factor.is_a?(Integer) && factor >= 2

    number_of_rows = size
    number_of_cols = first.size
    bigger_grid    = Array.new(number_of_rows * factor) { Array.new(number_of_cols * factor) }

    each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        0.upto(factor - 1) do |shift_row_index|
          0.upto(factor - 1) do |shift_col_index|
            bigger_grid[(row_index * factor) + shift_row_index][(col_index * factor) + shift_col_index] = cell
          end
        end
      end
    end

    bigger_grid
  end
end

module ArrayRefinements
  refine Array do
    import_methods ZoomifyArray
  end
end

# ### Solutions from the [Ruby Users Forum](https://www.rubyforum.org/t/cassidoo-s-interview-question-of-the-week-444/124)
#
# #### Flat & map from charlie
#
def charlie_zoom(matrix, factor)
  raise ArgumentError, "factor must be >= 2" unless factor >= 2

  matrix.map do |vector|
    repeated_items = vector.flat_map { [it] * factor }

    Array.new(factor, repeated_items)
  end.flatten(1)
end

# #### Enumerable version from lpogic
#
# Modified to be more readable (with AI)
#
module Enumerable
  def each_with_yielder
    Enumerator.new do |yielder|
      each { |item| yield(yielder, item) }
    end
  end
end

def lpogic_zoom(grid, factor)
  grid.each_with_yielder do |grid_yielder, row|
    factor.times do
      grid_yielder << row.each_with_yielder do |row_yielder, cell|
        factor.times do
          row_yielder << cell
        end
      end.to_a
    end
  end.to_a
end

# #### One-liner from fpsvogel
#
def fpsvogel_zoom(grid, factor) = grid.map { |row| row.flat_map { |col| [col] * factor } }.flat_map { |row| [row] * factor }

# #### Flat & map version from eayurt (AI used)
#
def eayurt_zoom(grid, factor)
  result = []

  grid.each do |row|
    zoomed_row = row.flat_map { |cell| [cell] * factor }
    factor.times { result << zoomed_row }
  end

  result
end

# #### Flat & map version from roasted-oolong (syntax corrected)
#
def roasted_oolong_zoom(grid, factor)
  return "error" if factor < 2

  grid.flat_map do |row|
    more_rows = row.flat_map { |n| [n] * factor } # Multiply rows by integer
    [more_rows] * factor # Repeat rows by integer
  end
end

# ## Question
#
# > You have a 2D grid of numbers.
# > Write a function that zooms in by an integer factor k >= 2
# > by turning each cell into a k x k block with the same value,
# > returning the bigger grid.
#
class Examples < Minitest::Test
  using ArrayRefinements

  def test_wrong_argument
    initial_grid = [[1]]

    assert_raises(ArgumentError) { initial_grid.zoom_in_by(1)   }
    assert_raises(ArgumentError) { initial_grid.zoom_in_by(2.0) }
  end

  def test_example_1
    initial_grid = [
      [1, 2],
      [3, 4]
    ]
    bigger_grid = [
      [1, 1, 2, 2],
      [1, 1, 2, 2],
      [3, 3, 4, 4],
      [3, 3, 4, 4]
    ]

    assert_equal bigger_grid, initial_grid.zoom_in_by(2)
    assert_equal bigger_grid, charlie_zoom(initial_grid, 2)
    assert_equal bigger_grid, lpogic_zoom(initial_grid, 2)
    assert_equal bigger_grid, fpsvogel_zoom(initial_grid, 2)
    assert_equal bigger_grid, eayurt_zoom(initial_grid, 2)
    assert_equal bigger_grid, roasted_oolong_zoom(initial_grid, 2)
  end

  def test_example_2
    initial_grid = [
      [7, 8, 9]
    ]
    bigger_grid = [
      [7, 7, 7, 8, 8, 8, 9, 9, 9],
      [7, 7, 7, 8, 8, 8, 9, 9, 9],
      [7, 7, 7, 8, 8, 8, 9, 9, 9]
    ]

    assert_equal bigger_grid, initial_grid.zoom_in_by(3)
    assert_equal bigger_grid, charlie_zoom(initial_grid, 3)
    assert_equal bigger_grid, lpogic_zoom(initial_grid, 3)
    assert_equal bigger_grid, fpsvogel_zoom(initial_grid, 3)
    assert_equal bigger_grid, eayurt_zoom(initial_grid, 3)
    assert_equal bigger_grid, roasted_oolong_zoom(initial_grid, 3)
  end

  def test_example_3
    initial_grid = [
      [1],
      [2]
    ]
    bigger_grid = [
      [1, 1, 1],
      [1, 1, 1],
      [1, 1, 1],
      [2, 2, 2],
      [2, 2, 2],
      [2, 2, 2]
    ]

    assert_equal bigger_grid, initial_grid.zoom_in_by(3)
    assert_equal bigger_grid, charlie_zoom(initial_grid, 3)
    assert_equal bigger_grid, lpogic_zoom(initial_grid, 3)
    assert_equal bigger_grid, fpsvogel_zoom(initial_grid, 3)
    assert_equal bigger_grid, eayurt_zoom(initial_grid, 3)
    assert_equal bigger_grid, roasted_oolong_zoom(initial_grid, 3)
  end
end
