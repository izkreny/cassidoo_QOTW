require "benchmark/ips"
require_relative "benchmarks_helpers"
require_relative "../answers/20260223"

module Benchmarks
  # - Questions::Issue20260223
  # - Answers::Issue20260223
  #
  # ---
  #
  module Issue20260223
    extend Answers::Issue20260223
    extend Benchmarks::Helpers
    using Benchmarks::Helpers::Refinements

    def self.benchmark_answers(warmup: 1, time: 1, quiet: false)
      methods   = Answers::Issue20260223.instance_methods(false)
      labels    = create_labels_for(methods, method_name: :max_subarray_sum)
      seed      = 666_999
      variants  = [
        {
          array_size: 100,
          skip_methods: %i[],
        },
        {
          array_size: 1_000,
          skip_methods: %i[],
        },
        # {
        #   array_size: 1_000_000,
        #   skip_methods: %i[
        #     fpsvogel_max_subarray_sum_map_each_cons_oneliner
        #     sean_max_subarray_sum_flat_map_each_cons_oneliner
        #   ],
        # },
      ]
      scenarios = [
        {
          title: :unique_negative,
          array: ->(size) { (-size...0).to_a.shuffle(random: Random.new(seed)) },
        },
        {
          title: :unique_positive,
          array: ->(size) { (0...size).to_a.shuffle(random: Random.new(seed)) },
        },
        {
          title: :unique_mixed,
          array: ->(size) { ((-size / 2)...(size / 2)).to_a.shuffle(random: Random.new(seed)) },
          skip_methods: ->(size) { size > 1_000 ? %i[izkreny_max_subarray_sum_times_slice_reduce] : [] },
        },
      ]

      scenarios.each do |scenario|
        variants.each do |variant|
          size                 = variant[:array_size]
          skip_methods         = variant[:skip_methods]
          title                = scenario[:title].to_s.gsub("_", " ")
          integers             = scenario[:array].call(size)
          skip_methods        += scenario[:skip_methods].call(size) if scenario.key?(:skip_methods)
          scenario_description =
            <<~MARKDOWN
              # #### Array of #{size.to_unds} #{title} integers
              #
            MARKDOWN

          puts scenario_description

          Benchmark.ips do |x|
            x.config(warmup: warmup, time: time, quiet: quiet)

            methods.each do |method|
              next if skip_methods.include?(method)

              x.report(labels[method]) { public_send(method, integers) }
            end

            x.compare!
          end

          print_labels_for_skipped_metods(labels, skip_methods) unless skip_methods.empty?
        end
      end
    end

    benchmark_answers
  end
end
