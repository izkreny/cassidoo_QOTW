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

  def test_find_method_base_name
    expected = "method_base_name"

    assert_equal expected, @benchmark.instance_variable_get(:@method_base_name)
    assert_equal expected, @benchmark.find_method_base_name
  end

  def test_generate_labels_for_methods
    expected = {
      john_doe_method_base_name_reduce: "john_doe ........... reduce ",
      mia_and_gaia_method_base_name_flat_map: "mia & gaia ....... flat_map ",
      dick_and_ai_method_base_name_sort_by!: "dick & AI ........ sort_by! ",
      cage_method_base_name_reduce: "cage ............... reduce ",
      john_and_maybe_ai_method_base_name_sum_max: "john & maybe AI ... sum_max ",
      philip_method_base_name_tap_map: "philip ............ tap_map ",
    }

    assert_equal expected, @benchmark.instance_variable_get(:@labels)
    assert_equal expected, @benchmark.generate_labels_for_methods
  end

  def test_fetch_skip_methods_from
    scenario = {
      name: :scenario_name,
    }
    variant = {
      skip_methods_for_scenario: {
        all: %i[
          slow_method
        ],
        scenario_name: %i[
          slowish_method
        ],
      },
    }
    expected = %i[
      slow_method
      slowish_method
    ]

    assert_equal expected, @benchmark.fetch_skip_methods_from(scenario, variant)
  end

  def test_fetch_skip_methods_from_variant
    scenario = {
      name: :scenario_name,
    }
    variant = {
      skip_methods_for_scenario: {
        all: %i[
          slow_method
        ],
      },
    }
    expected = %i[
      slow_method
    ]

    assert_equal expected, @benchmark.fetch_skip_methods_from(scenario, variant)
  end

  def test_fetch_skip_methods_from_empty_array
    scenario = {
      name: :scenario_name,
    }
    variant = {
      skip_methods_for_scenario: {
        all: %i[],
      },
    }
    expected = []

    assert_equal expected, @benchmark.fetch_skip_methods_from(scenario, variant)
  end

  def test_fetch_skip_methods_from_nil
    scenario = {
      name: :scenario_name,
    }
    variant = {}
    expected = []

    assert_equal expected, @benchmark.fetch_skip_methods_from(scenario, variant)
  end
end
