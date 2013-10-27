require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec_for_appraisal)

# Override the default task
task :default => [] # Just in case it hasn't already been set
Rake::Task[:default].clear
task :default => :appraise

task :appraise do |t|
  if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
    Rake::Task[:spec_for_appraisal].invoke
  else
    exec 'rake appraisal:install && rake appraisal'
  end
end

task :spec do |t|
  warn "To run the specs please use `rake` (or for faster tests, `rake appraise`)"
end