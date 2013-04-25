class Employee < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include CanCan::ModelAdditions
end
