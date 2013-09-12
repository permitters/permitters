ENV['RAILS_ENV'] = 'test'

require 'simplecov'
SimpleCov.start do
  add_filter '/gemfiles/'
  add_filter '/spec/'
  add_filter '/temp/'
end

spv = ''
begin
  require 'strong_parameters/version'
  spv = " with Strong Parameters v#{StrongParameters::VERSION}"
rescue Exception
end

# Note: edge may be displayed as a version that it isn't
puts "Testing Rails v#{Rails.version}#{spv}"

# add dummy to the load path. now we're also at the root of the fake rails app.
app_path = File.expand_path("../dummy",  __FILE__)
$LOAD_PATH.unshift(app_path) unless $LOAD_PATH.include?(app_path)

# if require rails, get uninitialized constant ActionView::Template::Handlers::ERB::ENCODING_FLAG (NameError)
require 'rails/all'
require 'config/environment'
require 'db/schema'
require 'rails/test_help'
require 'rspec/rails'

Rails.backtrace_cleaner.remove_silencers!

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  require 'rspec/expectations'
  config.include RSpec::Matchers
  config.mock_with :rspec
  config.order = :random
end

# ALREADY IN MODEL. INCLUDING ForbiddenAttributesProtection TWICE WILL RESULT IN: SystemStackError: stack level too deep
#ActiveRecord::Base.send(:include, ActiveModel::ForbiddenAttributesProtection)
#ActiveRecord::Base.send(:include, CanCan::ModelAdditions)
#ActionController::Base.send(:include, ActionController::Permittance)
