require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default do |t|
  if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
    exec 'rake spec'
  else
    exec 'rake appraise'
  end
end

task :appraise => ['appraisal:install'] do |t|
  exec 'rake appraisal'
end