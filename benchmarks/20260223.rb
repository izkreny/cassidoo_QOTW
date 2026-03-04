require "benchmark/ips"
require_relative "benchmarks_helpers"
require_relative "../answers/20260223"

module Benchmarks
  # - Questions::Issue20260223
  # - Answers::Issue20260223
  #
  # ---
  #
  # ```
  # ruby 4.0.1 (2026-01-13 revision e04267a14b) +YJIT +PRISM [x86_64-linux]
  # ```
  #
  # #### Array of 1_000 unique negative integers
  #
  # ```
  # eayurt ........................ each :   113804.1 i/s
  # fpsvogel ................. drop_each :   113086.7 i/s - same-ish: difference falls within error
  # josh_dev .................... reduce :    38288.6 i/s -     2.97x  slower
  # izkreny ......... times_slice_reduce :    35141.5 i/s -     3.24x  slower
  # lpogic ........ reduce_last_oneliner :    22463.3 i/s -     5.07x  slower
  # fpsvogel .... map_each_cons_oneliner :        3.8 i/s - 29904.19x  slower
  # sean ... flat_map_each_cons_oneliner :        3.6 i/s - 31400.30x  slower
  # ```
  #
  # #### Array of 1_000_000 unique negative integers
  #
  # ```
  # fpsvogel ................. drop_each :      113.4 i/s
  # eayurt ........................ each :      113.3 i/s - same-ish: difference falls within error
  # josh_dev .................... reduce :       37.3 i/s - 3.04x  slower
  # izkreny ......... times_slice_reduce :       35.6 i/s - 3.19x  slower
  # lpogic ........ reduce_last_oneliner :       22.0 i/s - 5.15x  slower
  # fpsvogel .... map_each_cons_oneliner :        ?!? i/s - too slow to calculate, sorry! 🐌
  # sean ... flat_map_each_cons_oneliner :        ?!? i/s - too slow to calculate, sorry! 🐢
  # ```
  #
  # #### Array of 1_000 unique positive integers
  #
  # ```
  # fpsvogel ................. drop_each :   112865.4 i/s
  # eayurt ........................ each :   112375.8 i/s - same-ish: difference falls within error
  # josh_dev .................... reduce :    37842.8 i/s -     2.98x  slower
  # izkreny ......... times_slice_reduce :    35318.0 i/s -     3.20x  slower
  # lpogic ........ reduce_last_oneliner :    22290.2 i/s -     5.06x  slower
  # fpsvogel .... map_each_cons_oneliner :        3.8 i/s - 30083.98x  slower
  # sean ... flat_map_each_cons_oneliner :        3.6 i/s - 31127.79x  slower
  #
  # ```
  #
  # #### Array of 1_000_000 unique positive integers
  #
  # ```
  # fpsvogel ................. drop_each :      113.0 i/s
  # eayurt ........................ each :      112.5 i/s - same-ish: difference falls within error
  # josh_dev .................... reduce :       36.8 i/s - 3.07x  slower
  # izkreny ......... times_slice_reduce :       35.2 i/s - 3.21x  slower
  # lpogic ........ reduce_last_oneliner :       22.0 i/s - 5.13x  slower
  # fpsvogel .... map_each_cons_oneliner :        ?!? i/s - too slow to calculate, sorry! 🦥
  # sean ... flat_map_each_cons_oneliner :        ?!? i/s - too slow to calculate, sorry! 🐨
  # ```
  #
  # #### Array of 1_000 unique mixed integers
  #
  # ```
  # eayurt ........................ each :   106776.5 i/s
  # fpsvogel ................. drop_each :   106483.5 i/s - same-ish: difference falls within error
  # josh_dev .................... reduce :    36056.6 i/s -     2.96x  slower
  # lpogic ........ reduce_last_oneliner :    21745.2 i/s -     4.91x  slower
  # izkreny ......... times_slice_reduce :       79.9 i/s -  1336.56x  slower
  # fpsvogel .... map_each_cons_oneliner :        3.7 i/s - 28736.51x  slower
  # sean ... flat_map_each_cons_oneliner :        3.6 i/s - 29669.18x  slower
  # ```
  #
  # #### Array of 1_000_000 unique mixed integers
  #
  # ```
  # eayurt ........................ each :      113.0 i/s
  # fpsvogel ................. drop_each :      111.5 i/s - same-ish: difference falls within error
  # josh_dev .................... reduce :       37.2 i/s - 3.04x  slower
  # lpogic ........ reduce_last_oneliner :       21.7 i/s - 5.20x  slower
  # fpsvogel .... map_each_cons_oneliner :        ?!? i/s - too slow to calculate, sorry! 🐌
  # sean ... flat_map_each_cons_oneliner :        ?!? i/s - too slow to calculate, sorry! 🐢
  # izkreny ......... times_slice_reduce :        ?!? i/s - too slow to calculate, sorry! 🦥
  # ```
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

          benchmark.run(integers, scenario:, variant:, mode:)
        end
      end
    end

    benchmark_answers
  end
end
