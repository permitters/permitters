require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default do |t|
  if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
    exec 'rake spec'
  else
    Dir.glob(File.join(File.dirname(__FILE__), 'gemfiles', '*.gemfile*')).each { |f| File.delete(f) }
    exec 'rake appraise'
  end
end

task :appraise => ['appraisal:install'] do |t|
  exec 'rake appraisal'
end