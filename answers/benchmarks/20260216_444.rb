require "benchmark/ips"
require_relative "../code/20260216_444"
using ArrayRefinements

grid_10   = Array.new(10)   { Array.new(10)   { rand(10..99)     } }
grid_1000 = Array.new(1000) { Array.new(1000) { rand(1000..9999) } }

puts "==> Benchmarking 10x10 grid with random numbers from 10 to 99 and zoom in factor 1000"
Benchmark.ips do |x|
  x.config(warmup: 2, time: 5)

  x.report("izkreny_zoom        ") { grid_10.zoom_in_by           1000 }
  x.report("charlie_zoom        ") { charlie_zoom        grid_10, 1000 }
  x.report("lpogic_zoom         ") { lpogic_zoom         grid_10, 1000 }
  x.report("fpsvogel_zoom       ") { fpsvogel_zoom       grid_10, 1000 }
  x.report("eayurt_zoom         ") { eayurt_zoom         grid_10, 1000 }
  x.report("roasted_oolong_zoom ") { roasted_oolong_zoom grid_10, 1000 }

  x.compare!
end

puts "==> Benchmarking 1000x1000 grid with random numbers from 1000 to 9999 and zoom in factor 10"
Benchmark.ips do |x|
  x.config(warmup: 2, time: 5)

  x.report("izkreny_zoom        ") { grid_1000.zoom_in_by           10 }
  x.report("charlie_zoom        ") { charlie_zoom        grid_1000, 10 }
  x.report("lpogic_zoom         ") { lpogic_zoom         grid_1000, 10 }
  x.report("fpsvogel_zoom       ") { fpsvogel_zoom       grid_1000, 10 }
  x.report("eayurt_zoom         ") { eayurt_zoom         grid_1000, 10 }
  x.report("roasted_oolong_zoom ") { roasted_oolong_zoom grid_1000, 10 }

  x.compare!
end

# ==> Benchmarking 10x10 grid with random numbers from 10 to 99 and zoom in factor 1000
# ruby 4.0.1 (2026-01-13 revision e04267a14b) +YJIT +PRISM [x86_64-linux]
# Warming up --------------------------------------
# izkreny_zoom             1.000 i/100ms
# charlie_zoom           384.000 i/100ms
# lpogic_zoom              1.000 i/100ms
# fpsvogel_zoom          614.000 i/100ms
# eayurt_zoom            352.000 i/100ms
# roasted_oolong_zoom    598.000 i/100ms
# Calculating -------------------------------------
# izkreny_zoom              0.369  (± 0.0%) i/s     (2.71 s/i) -       2.000 in   5.420725s
# charlie_zoom              3.859k (± 3.8%) i/s  (259.11 μs/i) -     19.584k in   5.082082s
# lpogic_zoom               0.259  (± 0.0%) i/s     (3.86 s/i) -       2.000 in   7.740633s
# fpsvogel_zoom             5.890k (± 3.7%) i/s  (169.77 μs/i) -     30.086k in   5.114901s
# eayurt_zoom               3.668k (± 3.4%) i/s  (272.60 μs/i) -     18.656k in   5.091449s
# roasted_oolong_zoom       5.795k (± 3.4%) i/s  (172.57 μs/i) -     29.302k in   5.062521s
#
# Comparison:
# fpsvogel_zoom       :     5890.2 i/s
# roasted_oolong_zoom :     5794.7 i/s - same-ish: difference falls within error
# charlie_zoom        :     3859.3 i/s - 1.53x  slower
# eayurt_zoom         :     3668.4 i/s - 1.61x  slower
# izkreny_zoom        :        0.4 i/s - 15946.97x  slower
# lpogic_zoom         :        0.3 i/s - 22714.56x  slower
#
# ==> Benchmarking 1000x1000 grid with random numbers from 1000 to 9999 and zoom in factor 10
# ruby 4.0.1 (2026-01-13 revision e04267a14b) +YJIT +PRISM [x86_64-linux]
# Warming up --------------------------------------
# izkreny_zoom             1.000 i/100ms
# charlie_zoom             1.000 i/100ms
# lpogic_zoom              1.000 i/100ms
# fpsvogel_zoom            1.000 i/100ms
# eayurt_zoom              1.000 i/100ms
# roasted_oolong_zoom      1.000 i/100ms
# Calculating -------------------------------------
# izkreny_zoom              0.325 (± 0.0%) i/s     (3.08 s/i) -      2.000 in   6.164156s
# charlie_zoom              6.391 (± 0.0%) i/s  (156.48 ms/i) -     32.000 in   5.015285s
# lpogic_zoom               0.252 (± 0.0%) i/s     (3.96 s/i) -      2.000 in   7.944989s
# fpsvogel_zoom             6.273 (± 0.0%) i/s  (159.41 ms/i) -     32.000 in   5.113912s
# eayurt_zoom               6.345 (± 0.0%) i/s  (157.60 ms/i) -     32.000 in   5.058533s
# roasted_oolong_zoom       6.266 (± 0.0%) i/s  (159.59 ms/i) -     32.000 in   5.115178s
#
# Comparison:
# charlie_zoom        :        6.4 i/s
# eayurt_zoom         :        6.3 i/s - 1.01x  slower
# fpsvogel_zoom       :        6.3 i/s - 1.02x  slower
# roasted_oolong_zoom :        6.3 i/s - 1.02x  slower
# izkreny_zoom        :        0.3 i/s - 19.68x  slower
# lpogic_zoom         :        0.3 i/s - 25.34x  slower
