class EmployeesController < ApplicationController
  include ActionController::Permittance

  def create
    authorize! :create, Employee
    ::Employee.new(permitted_params).save!
    head :ok
  end

  def permitter_class
    EmployeePermitter
  end

end
