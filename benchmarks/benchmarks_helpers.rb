# Benchmarks for the Answers to the Interview Questions Of The Week
# from the _[rendezvous with cassidoo](https://cassidoo.co/newsletter/)_,
# a weekly tech newsletter by Cassidy Williams.
#
module Benchmarks
  # Helper methods, classes, modules, and refinements for benchmarks.
  #
  module Helpers
    # Various 'refinements' aka monkey-patched standard classes
    #
    module Refinements
      refine Integer do
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
    end

    # Main benchmark helper
    #
    class Specification
      RANDOM_NEW_SEED     = 666_999
      EMPTY_STRING        = ""
      SPACER              = "."
      MIN_SPACER_AMOUNT   = 3
      SKIPPED_METHOD_INFO = ":        ?!? i/s - too slow/big to calculate, sorry!"
      TEST_METHOD_INFO    = ":        ?!? i/s - DRY RUN!"

      attr_accessor :seed, :name

      def initialize(answers)
        @answers          = Object.new.extend(answers)
        @methods          = answers.instance_methods(false)
        @method_base_name = find_method_base_name
        @labels           = generate_labels_for_methods
        @seed             = RANDOM_NEW_SEED
        @name             = EMPTY_STRING
      end

      # Main method, wrapper for `Benchmark.ips`
      #
      def run(*method_arguments, scenario: {}, variant: {}, mode: :default, quiet: false)
        @skip_methods = fetch_skip_methods_from(scenario, variant)

        puts @name

        Benchmark.ips do |x|
          case mode
          when :dry_run then x.config(warmup: 1, time: 1, quiet: true)
          when :quick   then x.config(warmup: 1, time: 1, quiet: false)
          when :slow    then x.config(warmup: 3, time: 6, quiet: true)
          when :jruby   then x.config(warmup: 3, time: 6, quiet:, iterations: 2)
          end

          @methods.each do |method|
            next if @skip_methods.include?(method)

            if mode == :dry_run
              puts @labels[method] + TEST_METHOD_INFO
            else
              x.report(@labels[method]) { @answers.public_send(method, *method_arguments) }
            end
          end

          x.compare!
        end

        puts skipped_methods_for_print unless @skip_methods.empty?
        puts EMPTY_STRING              if     mode == :dry_run
      end

      def find_method_base_name
        @methods
          .map { |method_full_name| generate_slices_from(method_full_name) }
          .reduce(:&)
          .max_by(&:size)
          .join("_")
      end

      # Generate slices aka N-grams aka 'contiguous subarrays' (elements must be neighbors)
      #
      def generate_slices_from(method_name)
        words = method_name.to_s.split("_")
        (1..words.size).flat_map { words.each_cons(it).to_a }
      end

      # Prettier `benchmark-ips` labels identical in size
      #
      def generate_labels_for_methods
        labels   = {}
        max_size = 0

        @methods.each do |method|
          authors, description = method.to_s.split("_#{@method_base_name}_")
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

      def fetch_skip_methods_from(scenario, variant)
        return [] unless variant.key?(:skip_methods_for_scenario)

        methods_for   = variant[:skip_methods_for_scenario]
        skip_methods  = []
        skip_methods += methods_for[:all]            if methods_for[:all]
        skip_methods += methods_for[scenario[:name]] if methods_for[scenario[:name]]

        skip_methods
      end

      def skipped_methods_for_print
        @skip_methods.map { @labels[it] + SKIPPED_METHOD_INFO + SlowAnimal.show(before: " ") }
      end

      # Show a different slow animal each time `SlowAnimal.show` is called:
      #
      # - 🐨 - Koala
      # - 🐌 - Snail
      # - 🐢 - Turtle
      # - 🦥 - Sloth
      #
      class SlowAnimal
        @@slow_animals = ["🐨", "🐌", "🐢", "🦥"] # rubocop:disable Style/ClassVars

        def self.show(before: "", around: "", after: "")
          @@slow_animals.rotate!
          before + around + @@slow_animals.first + around + after
        end
      end
    end
  end
end
