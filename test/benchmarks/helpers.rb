require_relative "../test_helper"
require_relative "../../benchmarks/benchmarks_helpers"

module FakeAnswers
  def self.instance_methods(_)
    %i[
      john_doe_method_base_name_reduce
      mia_and_gaia_method_base_name_flat_map
      dick_and_ai_method_base_name_sort_by!
      cage_method_base_name_reduce
      john_and_maybe_ai_method_base_name_sum_max
      philip_method_base_name_tap_map
    ]
  end
end

class SpecificationTest < Minitest::Test
  include Benchmarks::Helpers

  def setup
    @benchmark = Benchmarks::Helpers::Specification.new(FakeAnswers)
  end

  def test_extract_method_base_name
    expected_result = "method_base_name"

    assert_equal expected_result, @benchmark.instance_variable_get(:@method_base_name)
  end
end
