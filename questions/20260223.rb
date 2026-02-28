require_relative "../test/test_helper"
require_relative "../answers/20260223"

module Questions
  # - Answers::Issue20260223
  #
  # ---
  #
  # ## Question
  #
  # > Given an array of integers,
  # > find the contiguous subarray that has the largest sum and return that sum.
  # > A subarray must contain at least one element.
  # > If all elements are negative, return the largest (least negative) value.
  # >
  # > _If you need a hint, look up Kadane's Algorithm!_
  #
  class Issue20260223 < Minitest::Test
    include Answers::Issue20260223

    # :section: Examples

    def setup
      @methods  = Answers::Issue20260223.instance_methods(false)
      @examples = [
        {
          integers: [5],
          expected_result: 5,
        },
        {
          integers: [-1, -2, -3, -4],
          expected_result: -1,
        },
        {
          integers: [5, 4, -1, 7, 8],
          expected_result: 23,
        },
        {
          integers: [-2, 1, -3, 4, -1, 2, 1, -5, 4],
          expected_result: 6,
        },
        # Extra example if all integers are positive
        {
          integers: [1, 2, 3, 4],
          expected_result: 10,
        },
      ]
    end

    # :section: Tests

    def test_answers
      @methods.each do |method|
        @examples.each do |example|
          actual_result = public_send(method, example[:integers])

          assert_equal example[:expected_result], actual_result, "Answer #{method} is not correct"
          refute_same  example[:integers],        actual_result, "Answer #{method} is messing with the integers"
        end
      end
    end
  end
end
