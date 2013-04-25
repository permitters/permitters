module Admin
  module HumanResources
    class EmployeesController < ApplicationController
      include ActionController::Permittance

      def create
        authorize! :create, Employee
        ::Employee.new(permitted_params).save!
        head :ok
      end
    end
  end
end
