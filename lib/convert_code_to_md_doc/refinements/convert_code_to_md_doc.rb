require_relative "uncommentify_string"
require_relative "markdownify_string"
require_relative "empty_lines_removal_tools"
require_relative "markdownify_array"

# Conversion Refinements
module ConverCodeToMdDocRefinements
  refine String do
    import_methods UncommentifyString
    import_methods MarkdownifyString

    def to_chomped_lines
      lines.map(&:chomp)
    end
  end

  refine Array do
    import_methods EmptyLinesRemovalTools
    import_methods MarkdownifyArray
  end
end
