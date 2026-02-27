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
  # #### Grid: 10x10 / Zoom in factor: 10
  #
  # ```
  # sean ...................... each_times :    81108.2 i/s
  # fuzzy ........... flat_map_reduce_push :    61471.9 i/s -  1.32x  slower
  # eayurt & AI ............ each_flat_map :    55466.4 i/s -  1.46x  slower
  # fpsvogel ....... map_flat_map_oneliner :    54621.5 i/s -  1.48x  slower
  # roasted_oolong & maybe AI ... flat_map :    53573.6 i/s -  1.51x  slower
  # charlie ......... map_flat_map_flatten :    49514.0 i/s -  1.64x  slower
  # izkreny ........ each_with_index_times :     7706.7 i/s - 10.52x  slower
  # lpogic ............. each_with_yielder :     2141.0 i/s - 37.88x  slower
  # ```
  #
  # #### Grid: 10x10 / Zoom in factor: 100
  #
  # ```
  # roasted_oolong & maybe AI ... flat_map :    25203.3 i/s
  # fuzzy ........... flat_map_reduce_push :    24467.5 i/s - same-ish: difference falls within error
  # fpsvogel ....... map_flat_map_oneliner :    23077.2 i/s - same-ish: difference falls within error
  # charlie ......... map_flat_map_flatten :    20941.5 i/s -   1.20x  slower
  # eayurt & AI ............ each_flat_map :    20350.5 i/s -   1.24x  slower
  # sean ...................... each_times :    10908.1 i/s -   2.31x  slower
  # izkreny ........ each_with_index_times :       95.4 i/s - 264.06x  slower
  # lpogic ............. each_with_yielder :       30.2 i/s - 835.42x  slower
  # ```
  #
  # #### Grid: 10x10 / Zoom in factor: 1000
  #
  # ```
  # roasted_oolong & maybe AI ... flat_map :     5608.2 i/s
  # fpsvogel ....... map_flat_map_oneliner :     5353.4 i/s - same-ish: difference falls within error
  # fuzzy ........... flat_map_reduce_push :     3908.9 i/s -     1.43x  slower
  # charlie ......... map_flat_map_flatten :     3704.7 i/s -     1.51x  slower
  # eayurt & AI ............ each_flat_map :     3633.5 i/s -     1.54x  slower
  # sean ...................... each_times :     1148.5 i/s -     4.88x  slower
  # izkreny ........ each_with_index_times :        0.7 i/s -  7587.58x  slower
  # lpogic ............. each_with_yielder :        0.3 i/s - 21420.58x  slower
  # ```
  #
  # #### Grid: 1000x1000 / Zoom in factor: 10
  #
  # ```
  # sean ...................... each_times :       10.5 i/s
  # fuzzy ........... flat_map_reduce_push :        6.6 i/s -  1.57x  slower
  # fpsvogel ....... map_flat_map_oneliner :        6.2 i/s -  1.69x  slower
  # roasted_oolong & maybe AI ... flat_map :        6.1 i/s -  1.72x  slower
  # eayurt & AI ............ each_flat_map :        5.9 i/s -  1.78x  slower
  # charlie ......... map_flat_map_flatten :        5.7 i/s -  1.84x  slower
  # izkreny ........ each_with_index_times :        0.6 i/s - 16.51x  slower
  # lpogic ............. each_with_yielder :        0.3 i/s - 38.99x  slower
  # ```
  #
  module Issue20260216
    extend Answers::Issue20260216
    extend Benchmarks::Helpers

    methods   = Answers::Issue20260216.instance_methods(false)
    labels    = create_labels_for(methods, method_name: :zoom)
    seed      = 666_999
    scenarios = [
      {
        grid_size: 10,
        zoom_factors: [
          10,
          100,
          1_000,
        ],
      },
      {
        grid_size: 1_000,
        zoom_factors: [
          10,
          # 100,    # This is a memory eater!!!
          # 1_000,  # This would require an insanelly amount of memory I suppose?!?
        ],
      },
    ]

    scenarios.each do |scenario|
      size    = scenario[:grid_size]
      factors = scenario[:zoom_factors]
      grid    = Array.new(size) { Array.new(size) { Random.new(seed).rand(1..size) } }

      factors.each do |factor|
        scenario_description =
          <<~MARKDOWN
            # #### Grid: #{size}x#{size} / Zoom in factor: #{factor}
            #
          MARKDOWN
        puts scenario_description

        Benchmark.ips do |x|
          x.config(warmup: 2, time: 5, quiet: false)

          methods.each do |method|
            x.report(labels[method]) { public_send(method, grid, factor) }
          end

          x.compare!
        end
      end
    end
  end
end
