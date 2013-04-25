class EmployeePermitter < ActionController::Permitter
  permit :id, :a
end
