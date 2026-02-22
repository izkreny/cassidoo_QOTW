require "benchmark/ips"
require_relative "benchmarks_helpers"
require_relative "../answers/20260209"

module Benchmarks
  # - Questions::Issue20260209
  # - Answers::Issue20260209
  #
  # ---
  #
  # ```
  # ruby 4.0.1 (2026-01-13 revision e04267a14b) +YJIT +PRISM [x86_64-linux]
  # ```
  #
  # #### 1_000 / 5
  #
  # - `1_000` - Integer array size (with initially all unique numbers)
  # - `5` - Number `n` occurrence inside the integer array
  #
  # ```
  # javier_cervantes ...................... delete :   127860.6 i/s
  # eayurt ................................. each! :    99908.9 i/s - 1.28x  slower
  # chadow ................................... map :    52077.6 i/s - 2.46x  slower
  # javier_cervantes & izkreny ... delete_flatten! :    29541.9 i/s - 4.33x  slower
  # charlie & fpsvogel ................... sort_by :    27716.0 i/s - 4.61x  slower
  # charlie & fpsvogel .................. sort_by! :    22428.6 i/s - 5.70x  slower
  # katafrakt .......... partition_reverse_flatten :    16215.8 i/s - 7.88x  slower
  # izkreny & andynu ........... partition_flatten :    16165.5 i/s - 7.91x  slower
  # ```
  #
  # #### 1_000 / 50
  #
  # - `1_000` - Integer array size (with initially all unique numbers)
  # - `50` - Number `n` occurrence inside the integer array
  #
  # ```
  # javier_cervantes ...................... delete :   108130.4 i/s
  # eayurt ................................. each! :    93775.9 i/s - 1.15x  slower
  # chadow ................................... map :    52228.9 i/s - 2.07x  slower
  # javier_cervantes & izkreny ... delete_flatten! :    28772.1 i/s - 3.76x  slower
  # charlie & fpsvogel ................... sort_by :    27025.7 i/s - 4.00x  slower
  # charlie & fpsvogel .................. sort_by! :    22049.8 i/s - 4.90x  slower
  # izkreny & andynu ........... partition_flatten :    16291.6 i/s - 6.64x  slower
  # katafrakt .......... partition_reverse_flatten :    16099.4 i/s - 6.72x  slower
  # ```
  #
  # #### 1_000 / 500
  #
  # - `1_000` - Integer array size (with initially all unique numbers)
  # - `500` - Number `n` occurrence inside the integer array
  #
  # ```
  # javier_cervantes ...................... delete :    90251.0 i/s
  # eayurt ................................. each! :    52059.6 i/s - 1.73x  slower
  # chadow ................................... map :    42435.5 i/s - 2.13x  slower
  # javier_cervantes & izkreny ... delete_flatten! :    25091.1 i/s - 3.60x  slower
  # charlie & fpsvogel ................... sort_by :    23684.6 i/s - 3.81x  slower
  # charlie & fpsvogel .................. sort_by! :    19865.7 i/s - 4.54x  slower
  # izkreny & andynu ........... partition_flatten :    16127.7 i/s - 5.60x  slower
  # katafrakt .......... partition_reverse_flatten :    15983.4 i/s - 5.65x  slower
  # ```
  #
  # #### 1_000_000 / 5_000
  #
  # - `1_000_000` - Integer array size (with initially all unique numbers)
  # - `5_000` - Number `n` occurrence inside the integer array
  #
  # ```
  # javier_cervantes ...................... delete :      117.8 i/s
  # eayurt ................................. each! :      102.8 i/s - 1.15x  slower
  # chadow ................................... map :       51.8 i/s - 2.28x  slower
  # javier_cervantes & izkreny ... delete_flatten! :       26.9 i/s - 4.38x  slower
  # charlie & fpsvogel ................... sort_by :       22.4 i/s - 5.25x  slower
  # charlie & fpsvogel .................. sort_by! :       19.0 i/s - 6.19x  slower
  # katafrakt .......... partition_reverse_flatten :       16.1 i/s - 7.30x  slower
  # izkreny & andynu ........... partition_flatten :       16.0 i/s - 7.35x  slower
  # ```
  #
  # #### 1_000_000 / 50_000
  #
  # - `1_000_000` - Integer array size (with initially all unique numbers)
  # - `50_000` - Number `n` occurrence inside the integer array
  #
  # ```
  # javier_cervantes ...................... delete :      106.1 i/s
  # eayurt ................................. each! :       88.4 i/s - 1.20x  slower
  # chadow ................................... map :       51.3 i/s - 2.07x  slower
  # javier_cervantes & izkreny ... delete_flatten! :       27.2 i/s - 3.90x  slower
  # charlie & fpsvogel ................... sort_by :       23.4 i/s - 4.54x  slower
  # charlie & fpsvogel .................. sort_by! :       20.5 i/s - 5.19x  slower
  # katafrakt .......... partition_reverse_flatten :       16.6 i/s - 6.38x  slower
  # izkreny & andynu ........... partition_flatten :       15.8 i/s - 6.73x  slower
  # ```
  #
  # #### 1_000_000 / 500_000
  #
  # - `1_000_000` - Integer array size (with initially all unique numbers)
  # - `500_000` - Number `n` occurrence inside the integer array
  #
  # ```
  # javier_cervantes ...................... delete :       66.1 i/s
  # eayurt ................................. each! :       46.3 i/s - 1.43x  slower
  # chadow ................................... map :       41.5 i/s - 1.59x  slower
  # javier_cervantes & izkreny ... delete_flatten! :       23.4 i/s - 2.82x  slower
  # charlie & fpsvogel ................... sort_by :       19.7 i/s - 3.36x  slower
  # charlie & fpsvogel .................. sort_by! :       16.2 i/s - 4.07x  slower
  # izkreny & andynu ........... partition_flatten :       16.1 i/s - 4.09x  slower
  # katafrakt .......... partition_reverse_flatten :       15.3 i/s - 4.31x  slower
  # ```
  #
  module Issue20260209
    extend Answers::Issue20260209
    extend Benchmarks::Helpers
    using Benchmarks::Helpers::Refinements

    method_names = Answers::Issue20260209.instance_methods(false)
    labels       = create_labels_for(method_names, "_move_numbers_")
    seed         = 666_999
    bench_specs  = [
      {
        integer_array_size: 1_000,
        number_occurrences: [
          5,
          50,
          500,
        ],
      },
      {
        integer_array_size: 1_000_000,
        number_occurrences: [
          5_000,
          50_000,
          500_000,
        ],
      },
    ]

    bench_specs.each do |spec|
      number        = spec[:integer_array_size]
      occurrences   = spec[:number_occurrences]
      integer_array = (0...number).to_a.shuffle(random: Random.new(seed))
      indexes       = integer_array.take(occurrences.max)

      occurrences.each do |amount|
        indexes.take(amount).each { integer_array[it] = number }
        log =
          <<~MARKDOWN
            # #### #{number.to_unds} / #{amount.to_unds}
            #
            # - `#{number.to_unds}` - Integer array size (with initially all unique numbers)
            # - `#{integer_array.count(number).to_unds}` - Number `n` occurrence inside the integer array
            #
          MARKDOWN
        puts log

        Benchmark.ips do |x|
          x.config(warmup: 2, time: 5)

          method_names.each do |method_name|
            x.report(labels[method_name]) { public_send(method_name, integer_array.clone, number) }
          end

          x.compare!
        end
      end
    end
  end
end
