require_relative "../test_helper"
require_relative "../../lib/convert_code_to_md_doc"
using ConverCodeToMdDocRefinements

class Converter < Minitest::Test
  def setup
    @ruby_code_with_comments =
      <<~FILE
        require "minitest/autorun"

        # ## Question
        #
        #
        # Comment paragraph before list:
        # - List item 1
        # - List item 2
        #

        def example = true


        # ## Answer
        def multiline_code(array)
          array
            .reverse
        end

      FILE
  end

  def test_load_file_from_disk
    ruby_file = StringIO.new(@ruby_code_with_comments)

    assert_equal @ruby_code_with_comments.to_chomped_lines, load_content_from(ruby_file)
  end

  def test_uncommenting_string
    assert_equal "Comment",                 "# Comment".uncomment
    assert_equal "## Correct heading",      "# ## Correct heading".uncomment
    assert_equal "# Broken heading",        "## Broken heading".uncomment
    assert_equal "  # Nested code comment", "  # Nested code comment".uncomment
    assert_equal "def axiom = true",        "def axiom = true".uncomment
  end

  def test_conversion_from_ruby_to_markdown
    markdown =
      <<~MARKDOWN
        ## Question

        Comment paragraph before list:
        - List item 1
        - List item 2

        ```ruby
        def example = true
        ```

        ## Answer ([source code](../source.rb))

        ```ruby
        def multiline_code(array)
          array
            .reverse
        end
        ```
      MARKDOWN

    assert_equal markdown, @ruby_code_with_comments.to_chomped_lines.to_md.join("\n") << "\n"
  end
end

class FencedCodeBlockSpacingFix < Minitest::Test
  def test_correct_opening_fence_fix
    code_block_with_correct_opening_fence =
      <<~FENCED_RUBY_CODE_BLOCK
        ```ruby
        def axiom = true
        ```
      FENCED_RUBY_CODE_BLOCK
      .to_chomped_lines
    correct_fenced_code_block =
      <<~FENCED_RUBY_CODE_BLOCK
        ```ruby
        def axiom = true
        ```
      FENCED_RUBY_CODE_BLOCK
      .to_chomped_lines

    assert_equal(
      correct_fenced_code_block,
      code_block_with_correct_opening_fence
        .check_and_fix_spacing_for_opening_code_fences
    )
  end

  def test_incorrect_opening_fence_fix
    code_block_with_incorrect_opening_fence =
      <<~FENCED_RUBY_CODE_BLOCK

        Method description
        ```ruby

        def axiom = true
        ```
      FENCED_RUBY_CODE_BLOCK
      .to_chomped_lines
    correct_fenced_code_block =
      <<~FENCED_RUBY_CODE_BLOCK

        Method description

        ```ruby
        def axiom = true
        ```
      FENCED_RUBY_CODE_BLOCK
      .to_chomped_lines

    assert_equal(
      correct_fenced_code_block,
      code_block_with_incorrect_opening_fence
        .check_and_fix_spacing_for_opening_code_fences
    )
  end

  def test_correct_closing_fence_fix
    code_block_with_correct_closing_fence =
      <<~FENCED_RUBY_CODE_BLOCK
        ```ruby
        def axiom = true
        ```
      FENCED_RUBY_CODE_BLOCK
      .to_chomped_lines
    correct_fenced_code_block =
      <<~FENCED_RUBY_CODE_BLOCK
        ```ruby
        def axiom = true
        ```
      FENCED_RUBY_CODE_BLOCK
      .to_chomped_lines

    assert_equal(
      correct_fenced_code_block,
      code_block_with_correct_closing_fence
        .check_and_fix_spacing_for_closing_code_fences
    )
  end

  def test_incorrect_closing_fence_fix
    code_block_with_incorrect_closing_fence =
      <<~FENCED_RUBY_CODE_BLOCK
        ```ruby
        def axiom = true

        ```
        ### Heading

      FENCED_RUBY_CODE_BLOCK
      .to_chomped_lines
    correct_fenced_code_block =
      <<~FENCED_RUBY_CODE_BLOCK
        ```ruby
        def axiom = true
        ```

        ### Heading

      FENCED_RUBY_CODE_BLOCK
      .to_chomped_lines

    assert_equal(
      correct_fenced_code_block,
      code_block_with_incorrect_closing_fence
        .check_and_fix_spacing_for_closing_code_fences
    )
  end
end
