# Markdown String tools
module MarkdownifyString
  COMMONMARK_ATX_HEADINGS_RULE = /\A\s{0,3}\#{1,6}\s+/
  OPENING_CODE_FENCE           = "```ruby"
  CLOSING_CODE_FENCE           = "```"

  def heading?            = match? COMMONMARK_ATX_HEADINGS_RULE
  def opening_code_fence? = eql?   OPENING_CODE_FENCE
  def closing_code_fence? = eql?   CLOSING_CODE_FENCE
end
