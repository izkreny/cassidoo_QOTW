require_relative "../test/test_helper"
require_relative "../answers/20260209"

module Questions
  # - Answers::Issue20260209
  #
  # ---
  #
  # ## Question
  #
  # > Given an integer array and a number `n`,
  # > move all of the `n`s to the end of the array
  # > while maintaining the relative order of the non-`n`s.
  # >
  # > _Bonus: do this without making a copy of the array!_
  #
  class Issue20260209 < Minitest::Test
    include Answers::Issue20260209

    # :section: Example

    def setup
      @methods         = Answers::Issue20260209.instance_methods(false)
      @integers        = [0, 2, 0, 3, 10]
      @number_n        = 0
      @expected_result = [2, 3, 10, 0, 0]
    end

    # :section: Tests

    def test_answers_with_examples
      @methods.each do |method|
        actual_result = public_send(method, @integers.clone, @number_n)

        assert_equal @expected_result, actual_result, "Answer #{method} is not correct"
      end
    end

    def test_answers_with_copy
      @methods.reject { it.end_with?("!") }.each do |method|
        integers      = @integers.clone
        actual_result = public_send(method, integers, @number_n)

        refute_same integers, actual_result, "Answer #{method} is not making a copy of array"
      end
    end

    def test_answers_without_copy
      @methods.select { it.end_with?("!") }.each do |method|
        integers      = @integers.clone
        actual_result = public_send(method, integers, @number_n)

        assert_same integers, actual_result, "Answer #{method} is making a copy of array"
      end
    end
  end
end
