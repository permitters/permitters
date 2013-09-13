source 'https://rubygems.org'

gemspec

gem 'appraisal', '~> 0.5.2'
gem 'bundler', '>= 1.2.2'
gem 'cancan', '~> 1.6.10'
gem 'i18n'
gem 'rspec', '~> 2.14.1'
gem 'rspec-rails', '~> 2.14.1'
gem 'sqlite3'

# excluding not_ci from bundler in .travis.yml,
# checking ENV['CI'] in spec_helper
group :not_ci do
  gem 'simplecov', '~> 0.7.1'
end
