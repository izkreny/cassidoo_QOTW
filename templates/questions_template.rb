require_relative "../test/test_helper"
require_relative "../answers/XXXXXXXX"

module Questions
  # - Answers::IssueXXXXXXXX
  #
  # ---
  #
  # ## Question
  #
  # >
  #
  class IssueXXXXXXXX < Minitest::Test
    include Answers::IssueXXXXXXXX

    # :section: Examples

    def setup
      @methods  = Answers::IssueXXXXXXXX.instance_methods(false)
      @examples = [
        {
          initial_value:,
          expected:,
        },
      ]
    end

    # :section: Tests

    def test_answers_with_examples
      @methods.each do |method|
        @examples.each do |example|
          actual = public_send(method, example[:initial_value]) # Use Kernel.clone on arguments if needed!

          assert_equal example[:expected], actual, "Answer #{method} is not correct"
        end
      end
    end
  end
end
