# Tools to remove unnecessary empty lines from the Array
module EmptyLinesRemovalTools
  def delete_consecutive_empty_lines
    chunk_while { |a, b| a.empty? && a == b }.map(&:first)
  end

  def strip_empty_lines
    shift if first.empty?
    pop   if last.empty?
    self
  end
end
