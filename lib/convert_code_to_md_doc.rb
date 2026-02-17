require_relative "convert_code_to_md_doc/refinements/convert_code_to_md_doc"
using ConverCodeToMdDocRefinements

def load_content_from(file)
  file.readlines.map(&:chomp)
end
