require "rake/testtask"

Rake::TestTask.new(:test_convert_code_to_md_doc) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
end

Rake::TestTask.new(:test_answers) do |t|
  t.libs << "answers/code"
  t.test_files = FileList["answers/code/*.rb"]
end

task default: :test_answers
