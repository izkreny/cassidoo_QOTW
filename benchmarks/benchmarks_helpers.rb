# Benchmarks for the Answers to the Interview Questions Of The Week
# from the _[rendezvous with cassidoo](https://cassidoo.co/newsletter/)_,
# a weekly tech newsletter by Cassidy Williams.
#
module Benchmarks
  # Helper methods, modules, and refinements for benchmarks.
  #
  module Helpers
    SPACER              = "."
    MIN_SPACER_AMOUNT   = 3
    SKIPPED_METHOD_INFO = ":        ?!? i/s - too slow to calculate, sorry!"

    module IntegerRefinements
      # Format Ruby Integers with underscore
      #
      # `Integer#to_unds` returns a string adding underscores
      # to improve readability for large Integer literals.
      #
      #     1000000000000000.to_unds      # => "1_000_000_000_000_000"
      #     100_00000_00_0000_00.to_unds  # => "1_000_000_000_000_000"
      #
      # - Original [source code](https://gist.github.com/knugie/4168392)
      # - Underscores in Numerics @ [Ruby Style Guide](https://rubystyle.guide/#underscores-in-numerics)
      #
      def to_unds
        to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1_")
      end
    end

    module Refinements # :nodoc:
      refine Integer do
        import_methods IntegerRefinements
      end
    end

    # Used for prettier `becnhmark-ips` labels printed in 'Comparison' section
    #
    def create_labels_for(methods, method_name: "")
      max_size = 0
      labels   = {}

      methods.each do |method|
        authors, description = method.to_s.split("_#{method_name}_")
        authors              = authors.gsub("_and_", " & ").gsub(/[_\s]ai/, " AI")
        size                 = (authors + description).size
        max_size             = size if size > max_size

        labels.merge!({ method => { authors: authors, description: description, size: size } })
      end

      labels.each do |method, label|
        spacing =
          if label[:size] < max_size
            SPACER * (MIN_SPACER_AMOUNT + max_size - label[:size])
          else
            SPACER * MIN_SPACER_AMOUNT
          end

        labels[method] = "#{label[:authors]} #{spacing} #{label[:description]} "
      end

      labels
    end

    class SlowAnimal
      @@slow_animals = ["🐨", "🐌", "🐢", "🦥"]

      def self.show(before: "", around: "", after: "")
        @@slow_animals.rotate!
        before + around + @@slow_animals.first + around + after
      end
    end

    def print_labels_for_skipped_metods(labels, skipped_methods)
      skipped_methods.each do |method|
        puts labels[method] + SKIPPED_METHOD_INFO + SlowAnimal.show(before: " ")
      end
    end
  end
end
