require_relative "../test/test_helper"
require_relative "../answers/20260302"

module Questions
  # - Answers::Issue20260302
  #
  # ---
  #
  # ## Question
  #
  # > Find the majority element in an array (one that appears more than n/2 times)
  # > in O(n) time and O(1) space without hashmaps.
  # >
  # > Hint: the [Boyer-Moore Voting algorithm](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore_majority_vote_algorithm)
  # > might help if you can't figure this one out!
  #
  class Issue20260302 < Minitest::Test
    include Answers::Issue20260302

    # :section: Examples

    def setup
      @methods  = Answers::Issue20260302.instance_methods(false)
      @examples = [
        {
          array: [2, 2, 1, 1, 2, 2, 1, 2, 2],
          expected_result: 2,
        },
        {
          array: [3, 3, 4, 2, 3, 3, 1],
          expected_result: 3,
        },
        # Extra example by izkreny
        {
          array: %w[x o o],
          expected_result: "o",
        },
      ]
    end

    # :section: Tests

    def test_answers_with_examples
      @methods.each do |method|
        @examples.each do |example|
          actual_result = public_send(method, example[:array])

          assert_equal example[:expected_result], actual_result, "Answer #{method} is not correct"
          refute_same  example[:array],           actual_result, "Answer #{method} is messing with the array"
        end
      end
    end
  end
end
