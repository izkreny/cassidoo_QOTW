require_relative "../test/test_helper"
require_relative "../answers/20260216"

module Question
  # ## Question
  #
  # > You have a 2D grid of numbers.
  # > Write a function that zooms in by an integer factor k >= 2
  # > by turning each cell into a k x k block with the same value,
  # > returning the bigger grid.
  #
  # - rdoc-ref:Answer::Issue20260216
  #
  class Issue20260216 < Minitest::Test
    include Answer::Issue20260216

    def test_wrong_argument
      initial_grid = [[1]]

      assert_raises(ArgumentError) { izkreny_zoom(initial_grid, 1)   }
      assert_raises(ArgumentError) { izkreny_zoom(initial_grid, 2.0) }
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

      assert_equal bigger_grid, izkreny_zoom(initial_grid, 2)
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

      assert_equal bigger_grid, izkreny_zoom(initial_grid, 3)
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

      assert_equal bigger_grid, izkreny_zoom(initial_grid, 3)
      assert_equal bigger_grid, charlie_zoom(initial_grid, 3)
      assert_equal bigger_grid, lpogic_zoom(initial_grid, 3)
      assert_equal bigger_grid, fpsvogel_zoom(initial_grid, 3)
      assert_equal bigger_grid, eayurt_zoom(initial_grid, 3)
      assert_equal bigger_grid, roasted_oolong_zoom(initial_grid, 3)
    end
  end
end
