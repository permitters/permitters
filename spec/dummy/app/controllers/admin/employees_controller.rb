module Admin
  class EmployeesController < ApplicationController
    include ActionController::Permittance

    def create
      authorize! :create, Employee
      ::Employee.new(permitted_params_using(Admin::EmployeePermitter)).save!
      head :ok
    end
  end
end
