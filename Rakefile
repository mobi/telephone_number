require "bundler/gem_tasks"
require "rake/testtask"
require "telephone_number"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

namespace :data do
  namespace :main do
    task :import  do
      TelephoneNumber::DataImporter.new(File.expand_path("data/telephone_number_data_file.xml")).import!
    end
  end

  namespace :test do
    task :import  do
      TelephoneNumber::TestDataGenerator.import!
    end
  end
end
