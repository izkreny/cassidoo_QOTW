require_relative "../test/test_helper"
require_relative "../answers/20260216"

module Questions
  # - Answers::Issue20260216
  #
  # ---
  #
  # ## Question
  #
  # > You have a 2D grid of numbers.
  # > Write a function that zooms in by an integer factor k >= 2
  # > by turning each cell into a k x k block with the same value,
  # > returning the bigger grid.
  #
  class Issue20260216 < Minitest::Test
    include Answers::Issue20260216

    # :section: Examples

    def setup
      @methods  = Answers::Issue20260216.instance_methods(false)
      @examples = [
        {
          initial_grid: [
            [1, 2],
            [3, 4],
          ],
          zoom_factor: 2,
          bigger_grid: [
            [1, 1, 2, 2],
            [1, 1, 2, 2],
            [3, 3, 4, 4],
            [3, 3, 4, 4],
          ],
        },
        {
          initial_grid: [
            [7, 8, 9],
          ],
          zoom_factor: 3,
          bigger_grid: [
            [7, 7, 7, 8, 8, 8, 9, 9, 9],
            [7, 7, 7, 8, 8, 8, 9, 9, 9],
            [7, 7, 7, 8, 8, 8, 9, 9, 9],
          ],
        },
        {
          initial_grid: [
            [1],
            [2],
          ],
          zoom_factor: 3,
          bigger_grid: [
            [1, 1, 1],
            [1, 1, 1],
            [1, 1, 1],
            [2, 2, 2],
            [2, 2, 2],
            [2, 2, 2],
          ],
        },
      ]
    end

    # :section: Tests

    def test_answers_with_examples
      @methods.each do |method|
        @examples.each do |example|
          bigger_grid = public_send(method, example[:initial_grid], example[:zoom_factor])

          assert_equal example[:bigger_grid],  bigger_grid, "Answer #{method} is not correct"
          refute_same  example[:initial_grid], bigger_grid, "Answer #{method} is messing with the grid"
        end
      end
    end

    def test_wrong_argument
      initial_grid = [[1]]

      assert_raises(ArgumentError) { izkreny_zoom_each_with_index_times(initial_grid, 1)   }
      assert_raises(ArgumentError) { izkreny_zoom_each_with_index_times(initial_grid, 2.0) }
    end
  end
end
