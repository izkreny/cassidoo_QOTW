module Answers
  # - Questions::Issue20260309
  # - Benchmarks::Issue20260309
  #
  module Issue20260309
    # :section: Original answers

    # First I tried to calculate this by brute force, simulating iteration through
    # the array of chars, swapping them as I went... but this was a dead end.
    #
    # ```ruby
    # def izkreny_min_swaps_to_alternate_while_double_times(string)
    #   chars   = string.chars
    #   iterate = string.size - 1
    #   swaps   = 0
    #
    #   string.size.times
    #     iterate.times do |index|
    #       next unless chars[index] != chars[index + 1] &&
    #                   (chars[index + 1] == chars[index + 2] ||
    #                   (chars[index + 2].nil? && chars[index] == chars[index - 1]))
    #
    #       chars[index], chars[index + 1] = chars[index + 1], chars[index]
    #       swaps += 1
    #
    #       next unless index > 1 && chars[index - 1] == chars[index - 2] && chars[index] != chars[index - 1]
    #
    #       chars[index], chars[index - 1] = chars[index - 1], chars[index]
    #       swaps += 1
    #     end
    #
    #     iterate -= 1
    #   end
    #
    #   chars[0] == chars[1] ? -1 : swaps
    # end
    # ```
    #
    # I knew the pattern was much simpler, but I was too deep in this "simulation" mode,
    # so after I got a hint from the [AI mentor](../AGENTS.md)
    # that the answer was hidden in the indexes, I was able to code this solution by myself.
    #
    def izkreny_and_ai_min_swaps_to_alternate_chars_each_with_index(string)
      chars        = string.chars
      a_char_count = chars.count("a")
      b_char_count = chars.size - a_char_count

      return -1 if (a_char_count - b_char_count).abs > 1

      if chars.size.even?
        # The result would be the same if b_indexes were used instead
        a_indexes_in_abab_pattern = Array.new(chars.size / 2) { it * 2     }
        a_indexes_in_baba_pattern = Array.new(chars.size / 2) { it * 2 + 1 }
        a_indexes_in_chars        = []
        chars.each_with_index { |char, index| a_indexes_in_chars << index if char == "a" }

        [
          (a_indexes_in_chars.sum - a_indexes_in_abab_pattern.sum).abs,
          (a_indexes_in_chars.sum - a_indexes_in_baba_pattern.sum).abs,
        ].min
      else
        majority_char_indexes_in_odd_sized_string = Array.new((chars.size / 2) + 1) { it * 2 }
        majority_char                             = a_char_count > b_char_count ? "a" : "b"
        majority_char_indexes                     = []
        chars.each_with_index { |char, index| majority_char_indexes << index if char == majority_char }

        (majority_char_indexes.sum - majority_char_indexes_in_odd_sized_string.sum).abs
      end
    end

    # This solution is inspired by the Gemini 3 Pro performant version,
    # but it is a little more efficient because it directly calculates
    # the sum of the first `n` even and odd numbers/indexes.
    #
    def izkreny_and_ai_min_swaps_to_alternate_each_char_with_index_performant(string)
      # The final result would be the same if we used b_char instead
      a_char_count       = 0
      a_char_indexes_sum = 0
      string.each_char.with_index do |char, index|
        if char == "a"
          a_char_count       += 1
          a_char_indexes_sum += index
        end
      end
      b_char_count = string.size - a_char_count

      return -1 if (a_char_count - b_char_count).abs > 1

      # Formula to calculate the sum of the first `n` odd and even numbers: `n**2` and `n * (n + 1)`
      # In our case: `a_char_count**2` and (because the first even number/index is always `0`)
      # `(a_char_count - 1) * ((a_char_count - 1) + 1)` -> `a_char_count**2 - a_char_count`
      if a_char_count > b_char_count     # "aba..." pattern
        (a_char_indexes_sum - (a_char_count**2 - a_char_count)).abs
      elsif a_char_count < b_char_count  # "bab..." pattern
        (a_char_indexes_sum - a_char_count**2).abs
      else
        a_char_indexes_in_baba_pattern_sum = a_char_count**2
        a_char_indexes_in_abab_pattern_sum = a_char_indexes_in_baba_pattern_sum - a_char_count

        [
          (a_char_indexes_sum - a_char_indexes_in_baba_pattern_sum).abs,
          (a_char_indexes_sum - a_char_indexes_in_abab_pattern_sum).abs,
        ].min
      end
    end

    # :section: AI answers

    def gpt_5_3_codex_copilot_ai_min_swaps_to_alternate_each_with_index_lambdas(string)
      chars = string.chars
      n = chars.length

      a_positions = []
      chars.each_with_index { |ch, i| a_positions << i if ch == "a" }

      count_a = a_positions.length
      count_b = n - count_a

      return -1 if (count_a - count_b).abs > 1

      # Cost if target alternation starts with "a" at index 0 (a on even indexes)
      cost_start_with_a = lambda do
        target_positions = []
        0.step(n - 1, 2) { |i| target_positions << i }
        a_positions.each_with_index.sum { |pos, idx| (pos - target_positions[idx]).abs }
      end

      # Cost if target alternation starts with "b" at index 0 (a on odd indexes)
      cost_start_with_b = lambda do
        target_positions = []
        1.step(n - 1, 2) { |i| target_positions << i }
        a_positions.each_with_index.sum { |pos, idx| (pos - target_positions[idx]).abs }
      end

      if n.odd?
        count_a > count_b ? cost_start_with_a.call : cost_start_with_b.call
      else
        [cost_start_with_a.call, cost_start_with_b.call].min
      end
    end

    def gemini_3_pro_web_ai_min_swaps_to_alternate_each_char_with_index_lambda(input_string)
      # 1. Validate if an alternating string is even possible
      char_counts = input_string.chars.tally
      count_a = char_counts['a'] || 0
      count_b = char_counts['b'] || 0

      return -1 if (count_a - count_b).abs > 1

      # 2. Collect the actual positions of all 'a' characters
      # We use each_with_index to be explicit about our data
      a_positions = []
      input_string.each_char.with_index do |char, index|
        a_positions << index if char == 'a'
      end

      # 3. Helper to calculate total distance to move 'a's to target slots
      # Target slots for 'a' start at 'offset' and jump by 2 (e.g., 0, 2, 4...)
      calculate_displacement = ->(start_offset) do
        a_positions.each_with_index.sum do |current_pos, i|
          target_pos = start_offset + (i * 2)
          (current_pos - target_pos).abs
        end
      end

      # 4. Determine the valid starting positions for 'a'
      # If counts are unequal, 'a' has only one possible starting slot
      if count_a > count_b
        calculate_displacement.call(0) # 'a' must be at indices 0, 2, 4...
      elsif count_b > count_a
        calculate_displacement.call(1) # 'a' must be at indices 1, 3, 5...
      else
        # If counts are equal, 'a' could start at 0 (abab) or 1 (baba)
        [calculate_displacement.call(0), calculate_displacement.call(1)].min
      end
    end

    # Performance Improvements
    #
    # - **Single Iteration (O(N))**: We count characters and calculate displacement in the same loop, avoiding the need to traverse the string twice.
    # - **Zero Array Allocations (O(1) space)**: Unlike the previous version which created an array of indices (`a_positions`),
    #   this version only uses integers. This significantly reduces memory overhead and garbage collection pressure for large strings.
    # - **Immediate Calculation**: We calculate `(current_index - target_index).abs` as we go, rather than storing indices and processing them later.
    #
    def gemini_3_pro_web_ai_min_swaps_to_alternate_each_char_with_index_performant(input_string)
      # Track how many 'a's and 'b's we've seen
      count_a = 0
      count_b = 0

      # Accumulate the displacement costs for both potential patterns
      # Pattern 1: "abab..." (a at 0, 2, 4...) -> 'a' targets even indices
      # Pattern 2: "baba..." (a at 1, 3, 5...) -> 'a' targets odd indices
      cost_a_starts_even = 0
      cost_a_starts_odd = 0

      input_string.each_char.with_index do |char, index|
        if char == 'a'
          # If 'a' is the Nth 'a' we've found, its target index is:
          # For even start: 0, 2, 4... -> (count_a * 2)
          # For odd start:  1, 3, 5... -> (count_a * 2) + 1
          cost_a_starts_even += (index - (count_a * 2)).abs
          cost_a_starts_odd  += (index - ((count_a * 2) + 1)).abs
          count_a += 1
        else
          count_b += 1
        end
      end

      # Return -1 if the counts differ by more than 1
      return -1 if (count_a - count_b).abs > 1

      # Return the cost for the valid pattern(s)
      if count_a > count_b
        cost_a_starts_even
      elsif count_b > count_a
        cost_a_starts_odd
      else
        # If counts are equal, both patterns are valid; take the cheaper one
        [cost_a_starts_even, cost_a_starts_odd].min
      end
    end

    # :section: Ruby Users Forum answers
    #
    # Topic [Cassidoo’s Interview question of the week | 447][ruf]
    #
    # [ruf]: https://www.rubyforum.org/t/cassidoo-s-interview-question-of-the-week-447/189

    def eayurt_and_ai_min_swaps_to_alternate_chars_each_with_index(s)
      n = s.length
      a = s.chars.each_with_index.filter_map { |c, i| i if c == 'a' }
      b_count = n - a.length

      swaps = ->(a_starts) {
        expected = a_starts ? (n + 1) / 2 : n / 2
        a.each_with_index.sum { |p, i| (p - (a_starts ? 2 * i : 2 * i + 1)).abs } if a.length == expected
      }

      if n.even?
        a.length == b_count ? [swaps.(true), swaps.(false)].min : -1
      elsif a.length == (n + 1) / 2 then swaps.(true)
      elsif b_count  == (n + 1) / 2 then swaps.(false)
      else -1
      end
    end

    # Original code layout:
    #
    # ```ruby
    # def swaps_to_pattern str, pattern
    #   cache = Hash.new -1
    #
    #   (0...str.size).map do |index|
    #     char = pattern[index % pattern.size]
    #     match_index = ((cache[char] + 1)...str.size).find{ str[it] == char }
    #     return unless match_index
    #     cache[char] = match_index
    #     index < match_index ? match_index - index : 0
    #   end.sum
    # end
    #
    # def minSwapsToAlternate str
    #   ab = swaps_to_pattern str, "ab"
    #   ba = swaps_to_pattern str, "ba"
    #   ab ? ba ? [ab, ba].min : ab : ba || -1
    # end
    # ```
    #
    def lpogic_min_swaps_to_alternate_two_methods(string)
      swaps_to_pattern = lambda do |str, pattern|
        cache = Hash.new(-1)

        (0...str.size).map do |index|
          char        = pattern[index % pattern.size]
          match_index = ((cache[char] + 1)...str.size).find { str[it] == char }
          return unless match_index

          cache[char] = match_index
          index < match_index ? match_index - index : 0
        end.sum
      end

      ab = swaps_to_pattern.call(string, "ab")
      ba = swaps_to_pattern.call(string, "ba")
      ab ? ba ? [ab, ba].min : ab : ba || -1
    end
  end
end
