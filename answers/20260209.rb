module Answer
  # - Question::Issue20260209
  module Issue20260209
    # :section: Original answer

    # Methods used:
    #
    # - [Enumerable#partition](https://docs.ruby-lang.org/en/master/Enumerable.html#method-i-partition)
    # - [Array#flatten](https://docs.ruby-lang.org/en/master/Array.html#method-i-flatten)
    #
    def izkreny_move_numbers(integer_array, number) = integer_array.partition { it != number }.flatten

    # :section: Ruby Users Forum answers

    # Slightly modified [Array#sort!][sort!] version from the [Ruby Users Forum][ruf].  
    # Should this solution qualify as the only one where copy of the array is not made? :)
    #
    # [sort!]: https://docs.ruby-lang.org/en/master/Array.html#method-i-sort-21
    # [ruf]:  https://www.rubyforum.org/t/cassidoo-s-interview-question-of-the-week-443/98
    #
    def charlie_move_numbers(integer_array, number) = integer_array.sort! { it == number ? 1 : 0 }
  end
end
