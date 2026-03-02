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
      SPACER              = "."
      MIN_SPACER_AMOUNT   = 3
      SKIPPED_METHOD_INFO = ":        ?!? i/s - too slow to calculate, sorry!"
      TEST_METHOD_INFO    = ":        ?!? i/s - TEST FAKE RUN!"
      RANDOM_SEED         = 666_999

      attr_accessor :seed, :name

      def initialize(answers)
        @answers          = Object.new.extend(answers)
        @methods          = answers.instance_methods(false)
        @method_base_name = find_method_base_name
        @labels           = generate_labels_for_methods
        @seed             = RANDOM_SEED
        @name             = ""
      end

      def run_for(*method_arguments, scenario: {}, variant: {}, mode: :quick)
        @skip_methods = fetch_skip_methods_from(scenario, variant)

        puts "" if mode == :test
        puts @name

        Benchmark.ips do |x|
          case mode
          when :test    then x.config(warmup: 1, time: 1, quiet: true)
          when :quick   then x.config(warmup: 1, time: 1, quiet: false)
          when :default then x.config(warmup: 2, time: 5, quiet: true)
          end

          @methods.each do |method|
            next if @skip_methods.include?(method)

            if mode == :test
              puts @labels[method] + TEST_METHOD_INFO
            else
              x.report(@labels[method]) { @answers.public_send(method, *method_arguments) }
            end
          end

          x.compare!
        end

        print_skipped_metods
      end

      # private

      # Prettier `becnhmark-ips` labels printed in 'Comparison' section
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

      def fetch_skip_methods_from(scenario, variant)
        return [] unless variant.key?(:skip_methods_for_scenario)

        methods_for   = variant[:skip_methods_for_scenario]
        skip_methods  = []
        skip_methods += methods_for[:all]            if methods_for.key?(:all)
        skip_methods += methods_for[scenario[:name]] if methods_for.key?(scenario[:name])

        skip_methods
      end

      class SlowAnimal
        @@slow_animals = ["🐨", "🐌", "🐢", "🦥"] # rubocop:disable Style/ClassVars

        def self.show(before: "", around: "", after: "")
          @@slow_animals.rotate!
          before + around + @@slow_animals.first + around + after
        end
      end

      def print_skipped_metods
        return if @skip_methods.empty?

        @skip_methods.each do |method|
          puts @labels[method] + SKIPPED_METHOD_INFO + SlowAnimal.show(before: " ")
        end
      end
    end
  end
end
