require "benchmark/ips"
require_relative "benchmarks_helpers"
require_relative "../answers/20260302"

module Benchmarks
  # - Questions::Issue20260302
  # - Answers::Issue20260302
  #
  # ---
  #
  # ```
  # ruby 4.0.1 (2026-01-13 revision e04267a14b) +YJIT +PRISM [x86_64-linux]
  # ```
  #
  # #### 1_000 randomly shuffled integers (499 unique ones)
  #
  # ```
  # boyer & moore ................ each :   200857.2 i/s
  # josh_dev ................... reduce :    38702.4 i/s -  5.19x  slower
  # josh_dev ... sort_midpoint_oneliner :    37353.5 i/s -  5.38x  slower
  # izkreny ..... tally_max_by_oneliner :    20046.4 i/s - 10.02x  slower
  # fpsvogel ........... reduce_chained :    18892.0 i/s - 10.63x  slower
  # ```
  #
  # #### 1_000_000 randomly shuffled integers (499_999 unique ones)
  #
  # ```
  # boyer & moore ................ each :      118.3 i/s
  # josh_dev ................... reduce :       38.2 i/s - 3.10x  slower
  # fpsvogel ........... reduce_chained :       19.9 i/s - 5.94x  slower
  # josh_dev ... sort_midpoint_oneliner :       15.6 i/s - 7.56x  slower
  # izkreny ..... tally_max_by_oneliner :       15.6 i/s - 7.57x  slower
  # ```
  #
  module Issue20260302
    using Benchmarks::Helpers::Refinements

    def self.benchmark_answers(mode: :slow)
      benchmark = Benchmarks::Helpers::Specification.new(Answers::Issue20260302)
      scenarios = [
        1_000,
        1_000_000,
      ]

      scenarios.each do |size|
        array = (0...size).to_a.shuffle(random: Random.new(benchmark.seed))
        array.take((size / 2) + 1).each { array[it] = size }
        benchmark.name =
          <<~MARKDOWN
            # #### #{size.to_unds} randomly shuffled integers (#{(size - array.count(size)).to_unds} unique ones)
            #
          MARKDOWN

        benchmark.run(array, mode:)
      end
    end

    benchmark_answers
  end
end
