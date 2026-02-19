require "benchmark/ips"
require_relative "../code/20260216_444"
using ArrayRefinements

grid_10  = Array.new(10)  { Array.new(10)  { rand(10..99)   } }
grid_100 = Array.new(100) { Array.new(100) { rand(100..999) } }

puts "==> Benchmarking 10x10 grid with random numbers from 10 to 99 and factor 10"
Benchmark.ips do |x|
  x.config(warmup: 2, time: 5)

  x.report("izkreny_zoom        ") { grid_10.zoom_in_by(10)          }
  x.report("charlie_zoom        ") { charlie_zoom        grid_10, 10 }
  x.report("lpogic_zoom         ") { lpogic_zoom         grid_10, 10 }
  x.report("fpsvogel_zoom       ") { fpsvogel_zoom       grid_10, 10 }
  x.report("eayurt_zoom         ") { eayurt_zoom         grid_10, 10 }
  x.report("roasted_oolong_zoom ") { roasted_oolong_zoom grid_10, 10 }

  x.compare!
end

puts "==> Benchmarking 100x100 grid with random numbers from 100 to 999 and factor 100"
Benchmark.ips do |x|
  x.config(warmup: 2, time: 5)

  x.report("izkreny_zoom        ") { grid_100.zoom_in_by(100)          }
  x.report("charlie_zoom        ") { charlie_zoom        grid_100, 100 }
  x.report("lpogic_zoom         ") { lpogic_zoom         grid_100, 100 }
  x.report("fpsvogel_zoom       ") { fpsvogel_zoom       grid_100, 100 }
  x.report("eayurt_zoom         ") { eayurt_zoom         grid_100, 100 }
  x.report("roasted_oolong_zoom ") { roasted_oolong_zoom grid_100, 100 }

  x.compare!
end

# ==> Benchmarking 10x10 grid with random numbers from 10 to 99 and factor 10
# ruby 4.0.1 (2026-01-13 revision e04267a14b) +YJIT +PRISM [x86_64-linux]
# Warming up --------------------------------------
# izkreny_zoom            364.000 i/100ms
# charlie_zoom             5.106k i/100ms
# lpogic_zoom             209.000 i/100ms
# fpsvogel_zoom            5.167k i/100ms
# eayurt_zoom              5.327k i/100ms
# roasted_oolong_zoom      5.185k i/100ms
# Calculating -------------------------------------
# izkreny_zoom              3.463k (± 1.3%) i/s  (288.75 μs/i) -     17.472k in   5.045991s
# charlie_zoom             51.352k (± 2.0%) i/s   (19.47 μs/i) -    260.406k in   5.073118s
# lpogic_zoom               2.083k (± 1.8%) i/s  (479.98 μs/i) -     10.450k in   5.017523s
# fpsvogel_zoom            51.973k (± 1.9%) i/s   (19.24 μs/i) -    263.517k in   5.072110s
# eayurt_zoom              53.469k (± 2.5%) i/s   (18.70 μs/i) -    271.677k in   5.084349s
# roasted_oolong_zoom      52.711k (± 1.7%) i/s   (18.97 μs/i) -    264.435k in   5.018322s
#
# Comparison:
# eayurt_zoom         :    53469.0 i/s
# roasted_oolong_zoom :    52710.6 i/s - same-ish: difference falls within error
# fpsvogel_zoom       :    51973.2 i/s - same-ish: difference falls within error
# charlie_zoom        :    51352.4 i/s - same-ish: difference falls within error
# izkreny_zoom        :     3463.2 i/s - 15.44x  slower
# lpogic_zoom         :     2083.4 i/s - 25.66x  slower
#
# ==> Benchmarking 100x100 grid with random numbers from 100 to 999 and factor 100
# ruby 4.0.1 (2026-01-13 revision e04267a14b) +YJIT +PRISM [x86_64-linux]
# Warming up --------------------------------------
# izkreny_zoom             1.000 i/100ms
# charlie_zoom            30.000 i/100ms
# lpogic_zoom              1.000 i/100ms
# fpsvogel_zoom           31.000 i/100ms
# eayurt_zoom             25.000 i/100ms
# roasted_oolong_zoom     29.000 i/100ms
# Calculating -------------------------------------
# izkreny_zoom              0.347 (± 0.0%) i/s     (2.88 s/i) -       2.000 in   5.774075s
# charlie_zoom            286.291 (± 4.2%) i/s    (3.49 ms/i) -      1.440k in   5.038385s
# lpogic_zoom               0.255 (± 0.0%) i/s     (3.93 s/i) -       2.000 in   7.870985s
# fpsvogel_zoom           275.924 (± 7.6%) i/s    (3.62 ms/i) -      1.395k in   5.089186s
# eayurt_zoom             284.645 (± 4.6%) i/s    (3.51 ms/i) -      1.425k in   5.017416s
# roasted_oolong_zoom     288.974 (± 4.2%) i/s    (3.46 ms/i) -      1.450k in   5.027366s
#
# Comparison:
# roasted_oolong_zoom :      289.0 i/s
# charlie_zoom        :      286.3 i/s - same-ish: difference falls within error
# eayurt_zoom         :      284.6 i/s - same-ish: difference falls within error
# fpsvogel_zoom       :      275.9 i/s - same-ish: difference falls within error
# izkreny_zoom        :        0.3 i/s - 832.38x  slower
# lpogic_zoom         :        0.3 i/s - 1135.40x  slower
