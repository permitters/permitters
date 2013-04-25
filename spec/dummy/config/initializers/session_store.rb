# Be sure to restart your server when you modify this file.

# although we could look at if Object.const_defined?('Jbuilder'), a better solution to do the right thing in this case
# between 4.0.0.beta1 and edge Rails which have same version but behave differently is to just try both and not fail.
if Rails::VERSION::MAJOR > 3
  begin; Dummy::Application.config.session_store :encrypted_cookie_store, key: '_Dummy_session'; rescue; end
  begin; Dummy::Application.config.session_store :cookie_store; rescue; end
end
