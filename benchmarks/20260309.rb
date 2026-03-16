require "benchmark/ips"
require_relative "benchmarks_helpers"
require_relative "../answers/20260309"

module Benchmarks
  # - Questions::Issue20260309
  # - Answers::Issue20260309
  #
  # ---
  #
  module Issue20260309
    using Benchmarks::Helpers::Refinements

    def self.benchmark_answers(mode: :slow)
      benchmark = Benchmarks::Helpers::Specification.new(Answers::Issue20260309, method_base_name: :min_swaps_to_alternate)
      scenarios = [
        {
          string_size: 10_000,
        },
        {
          string_size: 1_000_000,
        },
      ]
      variants = [
        {
          name: :equal,
          create_string: ->(size) { (["a"] * (size / 2) + ["b"] * ((size / 2) + 0)).shuffle(random: Random.new(benchmark.seed)).join },
          skip_methods_for_scenario: {
            all: %i[],
            scenario_name: %i[],
          },
        },
        {
          name: :different,
          create_string: ->(size) { (["a"] * (size / 2) + ["b"] * ((size / 2) + 1)).shuffle(random: Random.new(benchmark.seed)).join },
          skip_methods_for_scenario: {
            all: %i[],
            scenario_name: %i[],
          },
        },
      ]

      scenarios.each do |scenario|
        variants.each do |variant|
          string = variant[:create_string].call(scenario[:string_size])
          benchmark.name =
            <<~MARKDOWN
              # #### String with #{string.size.to_unds} randomly shuffled #{variant[:name].to_s.upcase} number of 'a' and 'b' characters
              #
            MARKDOWN

          benchmark.run(string, mode:)
        end
      end
    end

    benchmark_answers mode: :dry_run
  end
end
