require "benchmark/ips"
require_relative "benchmarks_helpers"
require_relative "../answers/20260216"

module Benchmarks
  # - Questions::Issue20260216
  # - Answers::Issue20260216
  #
  # ---
  #
  # ```
  # ruby 4.0.1 (2026-01-13 revision e04267a14b) +YJIT +PRISM [x86_64-linux]
  # ```
  #
  # #### Grid: 10x10 / Zoom in factor: 100
  #
  # ```
  # fuzzy ... flat_map_reduce_push_oneliner :    28851.0 i/s
  # roasted_oolong & maybe AI .... flat_map :    27781.4 i/s - same-ish: difference falls within error
  # fpsvogel ........ map_flat_map_oneliner :    27526.8 i/s - same-ish: difference falls within error
  # charlie .......... map_flat_map_flatten :    22474.7 i/s -    1.28x  slower
  # eayurt & AI ............. each_flat_map :    21528.4 i/s -    1.34x  slower
  # sean ....................... each_times :    10088.1 i/s -    2.86x  slower
  # izkreny ......... each_with_index_times :       91.7 i/s -  314.63x  slower
  # lpogic .............. each_with_yielder :       28.5 i/s - 1010.58x  slower
  # ```
  #
  # #### Grid: 10x10 / Zoom in factor: 1000
  #
  # ```
  # roasted_oolong & maybe AI .... flat_map :     5457.1 i/s
  # fpsvogel ........ map_flat_map_oneliner :     5418.9 i/s - same-ish: difference falls within error
  # fuzzy ... flat_map_reduce_push_oneliner :     4121.8 i/s -     1.32x  slower
  # eayurt & AI ............. each_flat_map :     3554.9 i/s -     1.54x  slower
  # charlie .......... map_flat_map_flatten :     3545.6 i/s -     1.54x  slower
  # sean ....................... each_times :     1089.7 i/s -     5.01x  slower
  # izkreny ......... each_with_index_times :        0.7 i/s -  7733.61x  slower
  # lpogic .............. each_with_yielder :        0.3 i/s - 19979.27x  slower
  # ```
  #
  # #### Grid: 1000x1000 / Zoom in factor: 10
  #
  # ```
  # sean ....................... each_times :       10.4 i/s
  # fuzzy ... flat_map_reduce_push_oneliner :        6.5 i/s -  1.59x  slower
  # fpsvogel ........ map_flat_map_oneliner :        6.2 i/s -  1.69x  slower
  # eayurt & AI ............. each_flat_map :        6.1 i/s -  1.71x  slower
  # charlie .......... map_flat_map_flatten :        6.1 i/s -  1.71x  slower
  # roasted_oolong & maybe AI .... flat_map :        6.0 i/s -  1.73x  slower
  # izkreny ......... each_with_index_times :        0.6 i/s - 16.68x  slower
  # lpogic .............. each_with_yielder :        0.3 i/s - 39.82x  slower
  # ```
  #
  module Issue20260216
    using Benchmarks::Helpers::Refinements

    def self.benchmark_answers(mode: :slow)
      benchmark = Benchmarks::Helpers::Specification.new(Answers::Issue20260216)
      scenarios = [
        {
          grid_size: 10,
          zoom_factors: [
            100,
            1_000,
          ],
        },
        {
          grid_size: 1_000,
          zoom_factors: [
            10,
            # 100,  # Too slow to run...
          ],
        },
      ]

      scenarios.each do |scenario|
        size     = scenario[:grid_size]
        variants = scenario[:zoom_factors]
        grid     = Array.new(size) { Array.new(size) { Random.new(benchmark.seed).rand(10..99) } }

        variants.each do |factor|
          benchmark.name =
            <<~MARKDOWN
              # #### Grid: #{size}x#{size} / Zoom in factor: #{factor}
              #
            MARKDOWN

          benchmark.run(grid, factor, mode:)
        end
      end
    end

    benchmark_answers
  end
end
