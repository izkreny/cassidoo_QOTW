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
  # #### 1_000 / 50
  #
  # - `1_000` - Integer array size (with initially all unique numbers)
  # - `50` - Number `n` occurrence inside the integer array
  #
  # ```
  #
  # eayurt ................................. each! :   547997.0 i/s
  # javier_cervantes ...................... delete :   228452.0 i/s - 2.40x  slower
  # chadow ................................... map :    56520.8 i/s - 9.70x  slower
  # javier_cervantes & izkreny ... delete_flatten! :    34201.4 i/s - 16.02x  slower
  # charlie & fpsvogel ................... sort_by :    32272.3 i/s - 16.98x  slower
  # charlie & fpsvogel .................. sort_by! :    26055.1 i/s - 21.03x  slower
  # izkreny & andynu ........... partition_flatten :    16647.6 i/s - 32.92x  slower
  # katafrakt .......... partition_reverse_flatten :    16303.1 i/s - 33.61x  slower
  #
  # ```
  #
  # #### 1_000 / 500
  #
  # - `1_000` - Integer array size (with initially all unique numbers)
  # - `500` - Number `n` occurrence inside the integer array
  #
  # ```
  #
  # eayurt ................................. each! :   964149.9 i/s
  # javier_cervantes ...................... delete :   405746.8 i/s - 2.38x  slower
  # chadow ................................... map :   101509.1 i/s - 9.50x  slower
  # javier_cervantes & izkreny ... delete_flatten! :    63010.2 i/s - 15.30x  slower
  # charlie & fpsvogel ................... sort_by :    58834.4 i/s - 16.39x  slower
  # charlie & fpsvogel .................. sort_by! :    48061.5 i/s - 20.06x  slower
  # izkreny & andynu ........... partition_flatten :    30019.1 i/s - 32.12x  slower
  # katafrakt .......... partition_reverse_flatten :    29763.6 i/s - 32.39x  slower
  #
  # ```
  #
  # #### 1_000_000 / 50_000
  #
  # - `1_000_000` - Integer array size (with initially all unique numbers)
  # - `50_000` - Number `n` occurrence inside the integer array
  #
  # ```
  #
  # eayurt ................................. each! :      564.9 i/s
  # javier_cervantes ...................... delete :      231.5 i/s - 2.44x  slower
  # chadow ................................... map :       53.4 i/s - 10.58x  slower
  # javier_cervantes & izkreny ... delete_flatten! :       32.3 i/s - 17.51x  slower
  # charlie & fpsvogel ................... sort_by :       27.6 i/s - 20.49x  slower
  # charlie & fpsvogel .................. sort_by! :       22.4 i/s - 25.22x  slower
  # katafrakt .......... partition_reverse_flatten :       16.7 i/s - 33.77x  slower
  # izkreny & andynu ........... partition_flatten :       16.5 i/s - 34.32x  slower
  #
  # ```
  #
  # #### 1_000_000 / 500_000
  #
  # - `1_000_000` - Integer array size (with initially all unique numbers)
  # - `500_000` - Number `n` occurrence inside the integer array
  #
  # ```
  #
  # eayurt ................................. each! :     1066.1 i/s
  # javier_cervantes ...................... delete :      418.6 i/s - 2.55x  slower
  # chadow ................................... map :      103.0 i/s - 10.35x  slower
  # javier_cervantes & izkreny ... delete_flatten! :       62.5 i/s - 17.04x  slower
  # charlie & fpsvogel ................... sort_by :       60.4 i/s - 17.65x  slower
  # charlie & fpsvogel .................. sort_by! :       47.6 i/s - 22.40x  slower
  # katafrakt .......... partition_reverse_flatten :       31.0 i/s - 34.42x  slower
  # izkreny & andynu ........... partition_flatten :       30.9 i/s - 34.50x  slower
  # ```
  #
  module Issue20260209
    using Benchmarks::Helpers::Refinements

    def self.benchmark_answers(mode: :slow)
      benchmark = Benchmarks::Helpers::Specification.new(Answers::Issue20260209)
      scenarios = [
        {
          integers_size: 1_000,
          number_of_occurrences: [
            50,
            500,
          ],
        },
        {
          integers_size: 1_000_000,
          number_of_occurrences: [
            50_000,
            500_000,
          ],
        },
      ]

      scenarios.each do |scenario|
        number   = scenario[:integers_size]
        variants = scenario[:number_of_occurrences]
        integers = (0...number).to_a.shuffle(random: Random.new(benchmark.seed))
        indexes  = integers.take(variants.max)

        variants.each do |amount|
          indexes.take(amount).each { integers[it] = number }
          benchmark.name =
            <<~MARKDOWN
              # #### #{number.to_unds} / #{amount.to_unds}
              #
              # - `#{number.to_unds}` - Integer array size (with initially all unique numbers)
              # - `#{integers.count(number).to_unds}` - Number `n` occurrence inside the integer array
              #
            MARKDOWN

          benchmark.run(integers.clone, number, mode:)
        end
      end
    end

    benchmark_answers
  end
end
