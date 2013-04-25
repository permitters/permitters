class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  class_attribute :test_role

  def current_user
    u = User.new
    u.role = self.test_role.to_s
    u
  end
end
