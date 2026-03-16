require_relative "../test/test_helper"
require_relative "../answers/20260309"

module Questions
  # - Answers::Issue20260309
  #
  # ---
  #
  # ## Question
  #
  # > Given a string `s` consisting only of 'a' and 'b',
  # > you may swap adjacent characters any number of times.
  # > Return the minimum number of adjacent swaps needed to transform `s` into
  # > an alternating string, either "ababab..." or "bababa...",
  # > or return `-1` if it's impossible.
  #
  class Issue20260309 < Minitest::Test
    include Answers::Issue20260309

    # :section: Examples

    def setup
      @methods  = Answers::Issue20260309.instance_methods(false)
      @examples = [
        {
          string: "aabb",
          expected: 1,
        },
        {
          string: "aaaabbbb",
          expected: 6,
        },
        {
          string: "aaab",
          expected: -1,
        },
        # Extra examples by izkreny
        {
          string: "ba",
          expected: 0,
        },
        {
          string: "baa",
          expected: 1,
        },
        {
          string: "bbbaa",
          expected: 3,
        },
      ]
    end

    # :section: Tests

    def test_answers_with_examples
      @methods.each do |method|
        @examples.each do |example|
          actual = public_send(method, example[:string])

          assert_equal example[:expected], actual, "Answer #{method} is not correct for '#{example[:string]}' string"
          refute_same  example[:string],   actual, "Answer #{method} is messing with the string"
        end
      end
    end
  end
end
