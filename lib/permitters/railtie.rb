require 'rails/railtie'

module Permitters
  class Railtie < ::Rails::Railtie
    initializer "permitters.config", :before => "action_controller.set_configs" do |app|
      ActionController::Permitter.authorizer = app.config.action_controller.delete(:authorizer)
      ActionController::Permitter.current_authorizer_method = app.config.action_controller.delete(:current_authorizer_method)
    end

    initializer "permitters.set_autoload_path", after: :load_config_initializers do
      permitters_path = "#{Rails.root}/app/permitters"
      ActiveSupport::Dependencies.autoload_paths << permitters_path unless ActiveSupport::Dependencies.autoload_paths.include?(permitters_path)
    end
  end
end
