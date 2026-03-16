require "benchmark/ips"
require_relative "benchmarks_helpers"
require_relative "../answers/20260309"

module Benchmarks
  # - Questions::Issue20260309
  # - Answers::Issue20260309
  #
  # ---
  #
  # ```
  # ruby 4.0.1 (2026-01-13 revision e04267a14b) +YJIT +PRISM [x86_64-linux]
  # ```
  #
  # # String with 10_000 randomly shuffled EQUAL number of 'a' and 'b' characters
  #
  # ```
  # izkreny & AI .......... each_char_with_index_performant :     1181.1 i/s
  # gemini_3_pro_web AI ... each_char_with_index_performant :     1160.2 i/s - same-ish: difference falls within error
  # izkreny & AI .................... chars_each_with_index :      612.1 i/s -  1.93x  slower
  # gemini_3_pro_web AI ....... each_char_with_index_lambda :      445.8 i/s -  2.65x  slower
  # eayurt & AI ..................... chars_each_with_index :      369.2 i/s -  3.20x  slower
  # gpt_5_3_codex_copilot AI ...... each_with_index_lambdas :      336.6 i/s -  3.51x  slower
  # lpogic .................................... two_methods :       89.5 i/s - 13.20x  slower
  # ```
  #
  # # String with 10_001 randomly shuffled DIFFERENT number of 'a' and 'b' characters
  #
  # ```
  # gemini_3_pro_web AI ... each_char_with_index_performant :     1176.6 i/s
  # izkreny & AI .......... each_char_with_index_performant :     1176.5 i/s - same-ish: difference falls within error
  # izkreny & AI .................... chars_each_with_index :      950.6 i/s -  1.24x  slower
  # eayurt & AI ..................... chars_each_with_index :      683.7 i/s -  1.72x  slower
  # gpt_5_3_codex_copilot AI ...... each_with_index_lambdas :      662.7 i/s -  1.78x  slower
  # gemini_3_pro_web AI ....... each_char_with_index_lambda :      532.5 i/s -  2.21x  slower
  # lpogic .................................... two_methods :       92.7 i/s - 12.70x  slower
  # ```
  #
  # # String with 1_000_000 randomly shuffled EQUAL number of 'a' and 'b' characters
  #
  # ```
  # izkreny & AI .......... each_char_with_index_performant :       12.2 i/s
  # gemini_3_pro_web AI ... each_char_with_index_performant :       12.0 i/s - same-ish: difference falls within error
  # izkreny & AI .................... chars_each_with_index :        6.9 i/s -  1.76x  slower
  # eayurt & AI ..................... chars_each_with_index :        5.1 i/s -  2.40x  slower
  # gpt_5_3_codex_copilot AI ...... each_with_index_lambdas :        4.7 i/s -  2.58x  slower
  # gemini_3_pro_web AI ....... each_char_with_index_lambda :        3.8 i/s -  3.18x  slower
  # lpogic .................................... two_methods :        1.0 i/s - 12.76x  slower
  # ```
  #
  # # String with 1_000_001 randomly shuffled DIFFERENT number of 'a' and 'b' characters
  #
  # ```
  # izkreny & AI .......... each_char_with_index_performant :       12.3 i/s
  # gemini_3_pro_web AI ... each_char_with_index_performant :       12.2 i/s - same-ish: difference falls within error
  # izkreny & AI .................... chars_each_with_index :       10.0 i/s -  1.22x  slower
  # gpt_5_3_codex_copilot AI ...... each_with_index_lambdas :        6.8 i/s -  1.81x  slower
  # eayurt & AI ..................... chars_each_with_index :        6.4 i/s -  1.91x  slower
  # gemini_3_pro_web AI ....... each_char_with_index_lambda :        4.4 i/s -  2.80x  slower
  # lpogic .................................... two_methods :        1.0 i/s - 12.71x  slower
  # ```
  #
  module Issue20260309
    using Benchmarks::Helpers::Refinements

    def self.benchmark_answers(mode: :slow)
      benchmark = Benchmarks::Helpers::Specification.new(Answers::Issue20260309)
      scenarios = [
        {
          string_size: 10_000,
        },
        {
          string_size: 1_000_000,
        },
      ]
      variants = [
        {
          name: :equal,
          create_string: ->(size) { (["a"] * (size / 2) + ["b"] * ((size / 2) + 0)).shuffle(random: Random.new(benchmark.seed)).join },
        },
        {
          name: :different,
          create_string: ->(size) { (["a"] * (size / 2) + ["b"] * ((size / 2) + 1)).shuffle(random: Random.new(benchmark.seed)).join },
        },
      ]

      scenarios.each do |scenario|
        variants.each do |variant|
          string = variant[:create_string].call(scenario[:string_size])
          benchmark.name =
            <<~MARKDOWN
              # #### String with #{string.size.to_unds} randomly shuffled #{variant[:name].to_s.upcase} number of 'a' and 'b' characters
              #
            MARKDOWN

          benchmark.run(string, mode:)
        end
      end
    end

    benchmark_answers
  end
end
