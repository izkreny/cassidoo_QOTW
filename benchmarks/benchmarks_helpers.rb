# Benchmarks for the Answers to the Interview Questions Of The Week
# from the _[rendezvous with cassidoo](https://cassidoo.co/newsletter/)_,
# a weekly tech newsletter by Cassidy Williams.
#
module Benchmarks
  # Helper methods, modules, and refinements for benchmarks.
  #
  module Helpers
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
    def create_labels_for(methods, split_pattern)
      max_size = 0
      labels   = {}

      methods.each do |method|
        authors, description = method.to_s.split(split_pattern)
        authors  = authors.gsub("_and_", " & ").gsub(/[_\s]ai/, " AI")
        max_size = (authors + description).size if (authors + description).size > max_size
        labels.merge!({ method => { authors: authors, description: description } })
      end

      labels.each_key do |method|
        authors     = labels[method][:authors]
        description = labels[method][:description]
        spacing     =
          if authors.size + description.size == max_size
            " ... "
          else
            " #{'.' * (max_size - authors.size - description.size + 3)} "
          end
        labels[method] = authors + spacing + description << " "
      end

      labels
    end
  end
end
