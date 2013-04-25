module Admin
  class EmployeePermitter < ActionController::Permitter
    resource :employee
    permit :id, :b
  end
end
