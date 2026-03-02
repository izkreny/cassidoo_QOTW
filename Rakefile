require "rake/testtask"

Rake::TestTask.new(:tests) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
end

Rake::TestTask.new(:test_answers) do |t|
  t.libs << "questions"
  t.test_files = FileList["questions/*.rb"]
end

task default: :test_answers
