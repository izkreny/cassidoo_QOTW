# Markdown Array tools
module MarkdownifyArray
  OPENING_CODE_FENCE = "```ruby"
  CLOSING_CODE_FENCE = "```"

  def delete_lines_that_load_files
    reject! { it.start_with?("require") }
  end

  def uncomment_commented_lines
    map(&:uncomment)
  end

  def fence_code_blocks # rubocop:disable Metrics/MethodLength
    code_block_open = false

    each_with_index do |line, index|
      if line.comment?
        if code_block_open
          insert(index, CLOSING_CODE_FENCE)
          code_block_open = false
        end
      else
        next if code_block_open || line.empty?

        insert(index, OPENING_CODE_FENCE)
        code_block_open = true
      end
    end

    code_block_open ? self << CLOSING_CODE_FENCE : self
  end

  def check_and_fix_spacing_for_headings
    each_with_index do |line, index|
      if line.heading?
        insert(index, "")     unless index.zero?       || self[index - 1].empty?
        insert(index + 1, "") unless index + 1 == size || self[index + 1].empty?
      end
    end
  end

  def check_and_fix_spacing_for_opening_code_fences
    each_with_index do |line, index|
      next unless line.opening_code_fence?

      # IMPORTANT! Always execute insert first and delete second, otherwise prepare for 🐛🐞🪳
      insert(index, "")    unless index.zero? || self[index - 1].empty?
      delete_at(index + 1) if     self[index + 1].empty?
    end
  end

  def check_and_fix_spacing_for_closing_code_fences
    each_with_index do |line, index|
      next unless line.closing_code_fence?

      # IMPORTANT! Always execute insert first and delete second, otherwise prepare for 🐛🐞🪳
      insert(index + 1, "") unless index + 1 == size || self[index + 1].empty?
      delete_at(index - 1)  if     self[index - 1].empty?
    end
  end

  def to_md
    delete_lines_that_load_files
      .fence_code_blocks
      .uncomment_commented_lines
      .check_and_fix_spacing_for_headings
      .delete_consecutive_empty_lines
      .check_and_fix_spacing_for_opening_code_fences
      .check_and_fix_spacing_for_closing_code_fences
      .strip_empty_lines
  end
end
