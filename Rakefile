require "bundler/gem_tasks"
require 'rspec/core/rake_task'

namespace :spec do
  desc "Run all specs"
  RSpec::Core::RakeTask.new(:all) do
    ENV['COVERAGE'] = 'true'
  end

  desc 'Run the Travis CI specs'
  task :travis do
    ENV['SPEC_OPTS'] = "--profile 5"
    Rake::Task['spec:all'].invoke
  end
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new do |t|
    t.options << '--config=./.hound.yml'
  end
  task default: ['rubocop']
  task 'spec:travis' ['rubocop']
rescue LoadError
  puts "Unable to load rubocop. Who will enforce your styles now?"
end

task default: ['spec:travis']
