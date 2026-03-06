module Answers
  # - Questions::Issue20260302
  # - Benchmarks::Issue20260302
  #
  module Issue20260302
    # :section: Original answer

    def izkreny_majority_element_tally_max_by_oneliner(array)
      array.tally.max_by { |_key, value| value }.first
    end

    # [Boyer-Moore Voting algorithm](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore_majority_vote_algorithm)
    # solution.
    #
    def boyer_and_moore_majority_element_each(array)
      majority_element = array.first
      counter          = 0

      array.each do |element|
        if counter.zero?
          majority_element = element
          counter  = 1
        elsif majority_element == element
          counter += 1
        else
          counter -= 1
        end
      end

      majority_element
    end

    # :section: Ruby Users Forum answers
    #
    # Topic [Cassidoo’s Interview question of the week | 446][ruf]
    #
    # [ruf]: https://www.rubyforum.org/t/cassidoo-s-interview-question-of-the-week-446/179

    # Boyer-Moore voting algorithm.
    #
    def fpsvogel_majority_element_reduce_chained(numbers)
      numbers
        .reduce([nil, 0]) { |(candidate, count), el|
          candidate = el if count.zero?
          [candidate, count + ((el == candidate) ? 1 : -1)]
        }
        .first
    end

    def josh_dev_majority_element_reduce(numbers)
      candidate = numbers.first

      numbers.reduce(0) do |vote_total, number|
        candidate = number if vote_total.zero?
        vote_total + (number == candidate ? 1 : -1)
      end

      candidate
    end

    # Original code layout:
    #
    # ```ruby
    # def majority_element(numbers)
    #   midpoint = numbers.size / 2
    #
    #   # because of the 'appears more than n/2 times' aspect,
    #   # the answer will equal the median of all the numbers
    #   numbers.sort[midpoint]
    # end
    # ```
    #
    def josh_dev_majority_element_sort_midpoint_oneliner(numbers)
      numbers.sort[numbers.size / 2]
    end
  end
end
