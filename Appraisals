#-------------------------------------------------------------#
# NOTE! KEEP THE LIST OF GEMFILES in .travis.yml UP TO DATE!! #
#-------------------------------------------------------------#

appraise 'rails_4.0.x' do
  gem 'rails', '~> 4.0'
  # includes its own strong parameters and get errors if we include it
end

# note: Rails 3.2.13 tested/works with SP 0.1.3 and up (through 0.2.x)
# note: Rails 3.1.12 tested/works with SP 0.1.5 and up (through 0.2.x)

appraise "rails_3.2.x_with_strong_parameters" do
  gem 'rails', '~> 3.2'
  gem 'strong_parameters'
end

appraise "rails_3.1.x_with_strong_parameters" do
  gem 'rails', '~> 3.1'
  gem 'strong_parameters'
end
