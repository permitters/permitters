require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# Override the default task
task :default => [] # Just in case it hasn't already been set
Rake::Task[:default].clear
task :default => :appraise

task :appraise do |t|
  if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
    Rake::Task[:spec].invoke
  else
    exec 'rake appraisal:install && rake appraisal'
  end
end
