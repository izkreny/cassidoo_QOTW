# Comments tools
module UncommentifyString
  COMMENT_PREFIX = /\A\#\s?/

  def comment?  = match?         COMMENT_PREFIX
  def uncomment = comment? ? sub(COMMENT_PREFIX, "") : self
end
