require "bundler/gem_tasks"
require "inch/rake"
require "rake/testtask"
require "standard/rake"

namespace :test do
  desc "Runs unit and integration tests"
  task all: ["test:unit", "test:integration"]

  Rake::TestTask.new(:unit) do |t|
    t.libs.concat(["lib", "test"])
    t.description = "Run unit tests"
    t.test_files = FileList["test/**/test_*.rb"].exclude("test/test_integration.rb")
    t.warning = false
  end

  Rake::TestTask.new(:integration) do |t|
    t.libs.concat(["lib", "test"])
    t.description = "Run integration tests"
    t.test_files = FileList["test/test_integration.rb"]
    t.warning = false
  end
end

task :test do
  require "fileutils"
  FileUtils.remove_entry("coverage", true)
  ENV["COVERAGE"] = "1"
  Rake::Task["test:all"].invoke
end

Inch::Rake::Suggest.new(:inch)

task default: ["test", "standard:fix", "inch"]
