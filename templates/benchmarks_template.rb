require "benchmark/ips"
require_relative "benchmarks_helpers"
require_relative "../answers/XXXXXXXX"

module Benchmarks
  # - Questions::IssueXXXXXXXX
  # - Answers::IssueXXXXXXXX
  #
  # ---
  #
  module IssueXXXXXXXX
    using Benchmarks::Helpers::Refinements

    def self.benchmark_answers(mode: :default)
      benchmark = Benchmarks::Helpers::Specification.new(Answers::IssueXXXXXXXX)
      scenarios = [
        {
          name: :unique_negative,
          # Scenario attribute
        },
      ]
      variants = [
        {
          # Variant attribute
          skip_methods_for_scenario: {
            all: %i[],
            scenario_name: %i[],
          },
        },
      ]

      scenarios.each do |scenario|
        # Define local scenario variables
        variants.each do |variant|
          # Define local variant variables
          benchmark.name =
            <<~MARKDOWN
              # #### SCENARIO AND/OR VARIANT NAME
              #
              # - `local_variable` - Local variable description
              #
            MARKDOWN

          # Use Kernel.clone on method_argument if any method is mutating the argument!
          benchmark.run_for(*method_arguments, scenario:, variant:, mode:)
        end
      end
    end

    benchmark_answers
  end
end
