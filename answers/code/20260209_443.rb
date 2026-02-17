require_relative "../../test/test_helper"

# ## Question
#
# > **Given an integer array and a number `n`,
# > move all of the `n`s to the end of the array
# > while maintaining the relative order of the non-`n`s.**\
# > Bonus: do this without making a copy of the array!
#
class Example < Minitest::Test
  def test_example_orig = assert_equal [2, 3, 10, 0, 0], move_numbers([0, 2, 0, 3, 10], 0)
  def test_example_sort = assert_equal [2, 3, 10, 0, 0], move_numbers_([0, 2, 0, 3, 10], 0)
end

# ## Answers
#
# Methods used:
# - [Enumerable#partition](https://docs.ruby-lang.org/en/master/Enumerable.html#method-i-partition)
# - [Array#flatten](https://docs.ruby-lang.org/en/master/Array.html#method-i-flatten)
# - [Array#sort!](https://docs.ruby-lang.org/en/master/Array.html#method-i-sort-21)
#
# ### Original
def move_numbers(integer_array, number) = integer_array.partition { it != number }.flatten

# ### Sort only!
#
# Slightly modified version from the [Ruby Users Forum](https://www.rubyforum.org/t/cassidoo-s-interview-question-of-the-week-443/98/3)
# Should this solution qualify as the only one where copy of the array is not made? :)
def move_numbers_(integer_array, number) = integer_array.sort! { it == number ? 1 : 0 }
