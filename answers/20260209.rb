module Answers
  # - Questions::Issue20260209
  # - Benchmarks::Issue20260209
  #
  module Issue20260209
    # :section: Original answer

    # Methods used:
    #
    # - [Enumerable#partition](https://docs.ruby-lang.org/en/master/Enumerable.html#method-i-partition)
    # - [Array#flatten](https://docs.ruby-lang.org/en/master/Array.html#method-i-flatten)
    #
    # Same answer by andynu @ Ruby Users Forum
    #
    def izkreny_and_andynu_move_numbers_partition_flatten(integers, number)
      integers.partition { it != number }.flatten
    end

    # :section: Ruby Users Forum answers
    #
    # Topic [Cassidoo’s Interview question of the week | 443][ruf]
    #
    # [ruf]: https://www.rubyforum.org/t/cassidoo-s-interview-question-of-the-week-443/98

    def katafrakt_move_numbers_partition_reverse_flatten(arr, num)
      arr.partition { it == num }.reverse.flatten
    end

    # Refinements by fpsvogel
    #
    module FlatReversePartition
      refine Enumerable do
        def flat_reverse_partition(el)
          sort_by { (it == el) ? 1 : 0 }
        end

        def flat_reverse_partition!(el)
          sort_by! { (it == el) ? 1 : 0 }
        end
      end
    end

    using FlatReversePartition

    # Refinement answer by fpsvogel: Answers::Issue20260209::FlatReversePartition
    #
    def charlie_and_fpsvogel_move_numbers_sort_by(arr, num)
      arr.flat_reverse_partition(num)
    end

    # Refinement answer by fpsvogel: Answers::Issue20260209::FlatReversePartition
    #
    def charlie_and_fpsvogel_move_numbers_sort_by!(arr, num)
      arr.flat_reverse_partition!(num)
    end

    def chadow_move_numbers_map(ary, num)
      new_ary      = []
      nums_to_move = []

      ary.map do |element|
        element == num ? nums_to_move << element : new_ary << element
      end

      new_ary + nums_to_move
    end

    def javier_cervantes_move_numbers_delete(numbers, num)
      count = numbers.count(num)
      numbers.delete(num)
      numbers + Array.new(count, num)
    end

    # Array#delete answer by javier.cervantes with Array#append and Array#flatten! by izkreny
    #
    def javier_cervantes_and_izkreny_move_numbers_delete_flatten!(numbers, num)
      count = numbers.count(num)
      numbers.delete(num)
      numbers.append([num] * count).flatten!
    end

    def eayurt_move_numbers_each!(array, number)
      return unless array.include? number

      write = 0

      array.each do |element|
        if element != number
          array[write] = element
          write += 1
        end
      end

      (write...array.length).each { |i| array[i] = number }

      array
    end
  end
end
