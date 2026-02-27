require "benchmark/ips"
require_relative "benchmarks_helpers"
require_relative "../answers/XXXXXXXX"

module Benchmarks
  # - Questions::IssueXXXXXXXX
  # - Answers::IssueXXXXXXXX
  #
  # ---
  #
  module IssueXXXXXXXX
    extend Answers::IssueXXXXXXXX
    extend Benchmarks::Helpers

    methods   = Answers::IssueXXXXXXXX.instance_methods(false)
    labels    = create_labels_for(methods, method_name:)
    seed      = 666_999
    scenarios = [
      {
        # scenario definition and its variants
      },
    ]

    scenarios.each do |scenario|
      # Assign scenario values to local variables

      variants.each do |variant|
        scenario_description =
          <<~MARKDOWN
            # #### SCENARIO TITLE
            #
            # - `local_variable` - Local variable description if needed
            #
          MARKDOWN
        puts scenario_description

        Benchmark.ips do |x|
          x.config(warmup: 2, time: 5, quiet: false)

          methods.each do |method|
            x.report(labels[method]) { public_send(method, **variant_arguments) } # Use Kernel.clone on arguments if needed!
          end

          x.compare!
        end
      end
    end
  end
end
