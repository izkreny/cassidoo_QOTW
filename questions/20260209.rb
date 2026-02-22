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
      @integer_array   = [0, 2, 0, 3, 10]
      @number_n        = 0
      @expected_result = [2, 3, 10, 0, 0]
    end

    # :section: Tests

    method_names = Answers::Issue20260209.instance_methods(false)

    method_names.each do |method_name|
      define_method("test_answers_#{method_name}") do
        actual_result = public_send(method_name, @integer_array, @number_n)

        assert_equal @expected_result, actual_result, "Answer #{method_name} is not correct"
      end
    end

    method_names.reject { it.end_with?("!") }.each do |method_name|
      define_method("test_with_copy_#{method_name}") do
        actual_result = public_send(method_name, @integer_array, @number_n)

        refute_same @integer_array, actual_result, "Answer #{method_name} is not correct"
      end
    end

    method_names.select { it.end_with?("!") }.each do |method_name|
      define_method("test_without_copy_#{method_name}") do
        actual_result = public_send(method_name, @integer_array, @number_n)

        assert_same @integer_array, actual_result, "Answer #{method_name} is not correct"
      end
    end
  end
end
