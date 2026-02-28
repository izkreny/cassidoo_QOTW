module Answers
  # - Questions::Issue20260223
  # - Benchmarks::Issue20260223
  #
  module Issue20260223
    # :section: Original answer

    def izkreny_max_subarray_sum_times_slice_reduce(integers)
      return integers.first if integers.size == 1

      negative_integers_count = integers.count(&:negative?)

      case negative_integers_count
      when 0
        integers.sum
      when integers.size
        integers.max
      else
        max_sum = 0

        integers.size.times do |index|
          integers.slice(index..).reduce(0) do |sum, integer|
            max_sum = [max_sum, sum += integer].max
            sum
          end
        end

        max_sum
      end
    end

    # :section: Ruby Users Forum answers
    #
    # Topic [Cassidoo’s Interview question of the week | 445][ruf]
    #
    # [ruf]: https://www.rubyforum.org/t/cassidoo-s-interview-question-of-the-week-445/151

    def lpogic_max_subarray_sum_reduce_last_oneliner(arr)
      arr.reduce([0, arr[0]]) { |acc, e| [n = [e + acc[0], e].max, [n, acc[1]].max] }.last
    end

    def josh_dev_max_subarray_sum_reduce(numbers)
      running_total = numbers.first

      numbers.reduce do |max_sum, number|
        running_total = [number, running_total + number].max
        [max_sum, running_total].max
      end
    end

    def sean_max_subarray_sum_flat_map_each_cons_oneliner(arr)
      (1..arr.size).flat_map { arr.each_cons(it).map(&:sum) }.max
    end

    def fpsvogel_max_subarray_sum_map_each_cons_oneliner(numbers)
      numbers.length.downto(1).map { |sublength| numbers.each_cons(sublength).map(&:sum).max }.max
    end

    def fpsvogel_max_subarray_sum_drop_each(numbers)
      running_total = max_sum = numbers.first

      numbers.drop(1).each do |n|
        running_total = [n, running_total + n].max
        max_sum = [max_sum, running_total].max
      end

      max_sum
    end

    def eayurt_max_subarray_sum_each(array)
      max_sum = array.first
      current_sum = array.first

      array[1..].each do |element|
        current_sum = [element, current_sum + element].max
        max_sum = [max_sum, current_sum].max
      end

      max_sum
    end
  end
end
