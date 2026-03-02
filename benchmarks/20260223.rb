require "benchmark/ips"
require_relative "benchmarks_helpers"
require_relative "../answers/20260223"

module Benchmarks
  # - Questions::Issue20260223
  # - Answers::Issue20260223
  #
  # ---
  #
  module Issue20260223
    using Benchmarks::Helpers::Refinements

    def self.benchmark_answers(mode: :default)
      benchmark = Benchmarks::Helpers::Specification.new(Answers::Issue20260223)
      scenarios = [
        {
          name: :unique_negative,
          array: ->(size) { (-size...0).to_a.shuffle(random: Random.new(benchmark.seed)) },
        },
        {
          name: :unique_positive,
          array: ->(size) { (0...size).to_a.shuffle(random: Random.new(benchmark.seed)) },
        },
        {
          name: :unique_mixed,
          array: ->(size) { ((-size / 2)...(size / 2)).to_a.shuffle(random: Random.new(benchmark.seed)) },
        },
      ]
      variants = [
        {
          array_size: 100,
        },
        {
          array_size: 1_000,
        },
        {
          array_size: 1_000_000,
          skip_methods_for_scenario: {
            all: %i[
              fpsvogel_max_subarray_sum_map_each_cons_oneliner
              sean_max_subarray_sum_flat_map_each_cons_oneliner
            ],
            unique_mixed: %i[
              izkreny_max_subarray_sum_times_slice_reduce
            ],
          },
        },
      ]

      scenarios.each do |scenario|
        variants.each do |variant|
          size           = variant[:array_size]
          name           = scenario[:name].to_s.gsub("_", " ")
          integers       = scenario[:array].call(size)
          benchmark.name =
            <<~MARKDOWN
              # #### Array of #{size.to_unds} #{name} integers
              #
            MARKDOWN

          benchmark.run_for(integers, scenario:, variant:, mode:)
        end
      end
    end

    benchmark_answers
  end
end
