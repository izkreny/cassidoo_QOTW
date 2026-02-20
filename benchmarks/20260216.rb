require "benchmark/ips"
require_relative "../answers/20260216"

module Benchmark
  # - Answer::Issue20260216
  #
  # `ruby 4.0.1 (2026-01-13 revision e04267a14b) +YJIT +PRISM [x86_64-linux]`
  #
  # #### Benchmarking 10x10 grid with random numbers from 10 to 99 and zoom in factor 1000
  #
  # ```
  # Comparison:
  # fpsvogel_zoom       :     5890.2 i/s
  # roasted_oolong_zoom :     5794.7 i/s - same-ish: difference falls within error
  # charlie_zoom        :     3859.3 i/s -     1.53x  slower
  # eayurt_zoom         :     3668.4 i/s -     1.61x  slower
  # izkreny_zoom        :        0.4 i/s - 15946.97x  slower
  # lpogic_zoom         :        0.3 i/s - 22714.56x  slower
  # ```
  #
  # #### Benchmarking 1000x1000 grid with random numbers from 1000 to 9999 and zoom in factor 10
  #
  # ```
  # Comparison:
  # charlie_zoom        :        6.4 i/s
  # eayurt_zoom         :        6.3 i/s -  1.01x  slower
  # fpsvogel_zoom       :        6.3 i/s -  1.02x  slower
  # roasted_oolong_zoom :        6.3 i/s -  1.02x  slower
  # izkreny_zoom        :        0.3 i/s - 19.68x  slower
  # lpogic_zoom         :        0.3 i/s - 25.34x  slower
  # ```
  #
  module Issue20260216
    extend Answer::Issue20260216

    grid_10   = Array.new(10)   { Array.new(10)   { rand(10..99)     } }
    grid_1000 = Array.new(1000) { Array.new(1000) { rand(1000..9999) } }

    puts "#### Benchmarking 10x10 grid with random numbers from 10 to 99 and zoom in factor 1000"
    Benchmark.ips do |x|
      x.config(warmup: 2, time: 5)

      x.report("izkreny_zoom        ") { izkreny_zoom        grid_10, 1000 }
      x.report("charlie_zoom        ") { charlie_zoom        grid_10, 1000 }
      x.report("lpogic_zoom         ") { lpogic_zoom         grid_10, 1000 }
      x.report("fpsvogel_zoom       ") { fpsvogel_zoom       grid_10, 1000 }
      x.report("eayurt_zoom         ") { eayurt_zoom         grid_10, 1000 }
      x.report("roasted_oolong_zoom ") { roasted_oolong_zoom grid_10, 1000 }

      x.compare!
    end

    puts "#### Benchmarking 1000x1000 grid with random numbers from 1000 to 9999 and zoom in factor 10"
    Benchmark.ips do |x|
      x.config(warmup: 2, time: 5)

      x.report("izkreny_zoom        ") { izkreny_zoom        grid_1000, 10 }
      x.report("charlie_zoom        ") { charlie_zoom        grid_1000, 10 }
      x.report("lpogic_zoom         ") { lpogic_zoom         grid_1000, 10 }
      x.report("fpsvogel_zoom       ") { fpsvogel_zoom       grid_1000, 10 }
      x.report("eayurt_zoom         ") { eayurt_zoom         grid_1000, 10 }
      x.report("roasted_oolong_zoom ") { roasted_oolong_zoom grid_1000, 10 }

      x.compare!
    end
  end
end
