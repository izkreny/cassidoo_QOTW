require_relative "../test/test_helper"
require_relative "../answers/20260209"

module Question
  # ## Question
  #
  # > Given an integer array and a number `n`,
  # > move all of the `n`s to the end of the array
  # > while maintaining the relative order of the non-`n`s.
  # >
  # > _Bonus: do this without making a copy of the array!_
  #
  # - Answer::Issue20260209
  #
  class Issue20260209 < Minitest::Test
    include Answer::Issue20260209

    def test_example
      integer_array = [0, 2, 0, 3, 10]
      expected      = [2, 3, 10, 0, 0]

      assert_equal expected, izkreny_move_numbers(integer_array, 0)
      assert_equal expected, charlie_move_numbers(integer_array, 0)
    end
  end
end
