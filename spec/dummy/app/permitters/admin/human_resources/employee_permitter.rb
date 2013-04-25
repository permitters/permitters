module Admin
  module HumanResources
    class EmployeePermitter < ActionController::Permitter
      resource :employee
      permit :id, :c
    end
  end
end
