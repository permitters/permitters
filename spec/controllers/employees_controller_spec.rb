require 'rails'
require 'spec_helper'

shared_examples_for 'valid employee controllers' do
  # turn on error raising for unpermitted parameters for 
  # easier testing
  before(:all) do
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end
  after(:all) do
    ActionController::Parameters.action_on_unpermitted_parameters = :log
  end

  let!(:unpermitted) { ActionController::UnpermittedParameters }

  describe ::EmployeesController do

    describe "POST create" do
      it 'allowed for accepted params' do
        ::EmployeesController.test_role = 'admin'
        ::Employee.delete_all
        name = ::SecureRandom.urlsafe_base64
        put :create, {employee: {a: name}}
        expect(response).to be_success, "create failed (got #{response.status}): #{response.body}"
      end

      it 'does not accept non-whitelisted params' do
        ::EmployeesController.test_role = 'admin'
        ::Employee.delete_all
        name = ::SecureRandom.urlsafe_base64
        
        expect { put :create, {employee: {b: name}} }.to raise_error(unpermitted),
               'permitters should not allow put'
      end

      it 'does not accept whitelisted params when cancan disallows user', if: @auth_configured do
        ::EmployeesController.test_role = 'nobody'
        ::Employee.delete_all
        name = ::SecureRandom.urlsafe_base64
        expect { put :create, {employee: {a: name}} }.to raise_error(unpermitted),
               'cancan should not allow put'
      end
    end
  end

  describe ::Admin::EmployeesController do

    describe "POST create" do
      it 'allowed for accepted params' do
        ::Admin::EmployeesController.test_role = 'admin'
        ::Employee.delete_all
        name = ::SecureRandom.urlsafe_base64
        put :create, {employee: {b: name}}
        expect(response).to be_success, "create failed (got #{response.status}): #{response.body}"
      end

      it 'does not accept non-whitelisted params' do
        ::Admin::EmployeesController.test_role = 'admin'
        ::Employee.delete_all
        name = ::SecureRandom.urlsafe_base64
        expect { put :create, {employee: {a: name}} }.to raise_error(unpermitted),
               'permitters should not allow put'
      end

      it 'does not accept whitelisted params when cancan disallows user', if: @auth_configured do
        ::Admin::EmployeesController.test_role = 'nobody'
        ::Employee.delete_all
        name = ::SecureRandom.urlsafe_base64
        expect { put :create, {employee: {b: name}} }.to raise_error(unpermitted),
               'cancan should not allow put'
      end
    end
  end

  describe ::Admin::HumanResources::EmployeesController do
    describe "POST create" do
      it 'allowed for accepted params' do
        ::Admin::HumanResources::EmployeesController.test_role = 'admin'
        ::Employee.delete_all
        name = ::SecureRandom.urlsafe_base64
        put :create, {employee: {c: name}}
        expect(response).to be_success, "create failed (got #{response.status}): #{response.body}"
      end

      it 'does not accept non-whitelisted params' do
        ::Admin::HumanResources::EmployeesController.test_role = 'admin'
        ::Employee.delete_all
        name = ::SecureRandom.urlsafe_base64
        expect { put :create, {employee: {a: name}} }.to raise_error(unpermitted),
               'permitters should not allow put'
      end

      it 'does not accept whitelisted params when cancan disallows user', if: @auth_configured do
        ::Admin::HumanResources::EmployeesController.test_role = 'nobody'
        ::Employee.delete_all
        name = ::SecureRandom.urlsafe_base64
        expect { put :create, {employee: {c: name}} }.to raise_error(unpermitted),
               'cancan should not allow put'
      end
    end
  end
end

# Running that suite of tests for different states

describe 'With Ability class configured' do
  before(:each) do
    @old_authorizer = ActionController::Permitter.authorizer
    @old_current_authorizer_method = ActionController::Permitter.current_authorizer_method
    ActionController::Permitter.authorizer = 'Ability'
    ActionController::Permitter.current_authorizer_method = nil
    @no_auth_configured = false
  end

  after(:each) do
    ActionController::Permitter.authorizer = @old_authorizer
    ActionController::Permitter.current_authorizer_method = @old_current_authorizer_method
  end

  it_should_behave_like 'valid employee controllers'
end

describe 'With current_ability method configured' do
  before(:each) do
    @old_authorizer = ActionController::Permitter.authorizer
    @old_current_authorizer_method = ActionController::Permitter.current_authorizer_method
    ActionController::Permitter.authorizer = 'Ability'
    ActionController::Permitter.current_authorizer_method = nil
    @auth_configured = true
  end

  after(:each) do
    ActionController::Permitter.authorizer = @old_authorizer
    ActionController::Permitter.current_authorizer_method = @old_current_authorizer_method
  end

  it_should_behave_like 'valid employee controllers'
end

describe 'With Ability class and current_ability method configured' do
  before(:each) do
    @old_authorizer = ActionController::Permitter.authorizer
    @old_current_authorizer_method = ActionController::Permitter.current_authorizer_method
    ActionController::Permitter.authorizer = 'Ability'
    ActionController::Permitter.current_authorizer_method = nil
    @auth_configured = true
  end

  after(:each) do
    ActionController::Permitter.authorizer = @old_authorizer
    ActionController::Permitter.current_authorizer_method = @old_current_authorizer_method
  end

  it_should_behave_like 'valid employee controllers'
end

describe 'With no auth configured' do
  before(:each) do
    @old_authorizer = ActionController::Permitter.authorizer
    @old_current_authorizer_method = ActionController::Permitter.current_authorizer_method
    ActionController::Permitter.authorizer = 'Ability'
    ActionController::Permitter.current_authorizer_method = nil
    @auth_configured = false
  end

  after(:each) do
    ActionController::Permitter.authorizer = @old_authorizer
    ActionController::Permitter.current_authorizer_method = @old_current_authorizer_method
    @auth_configured = true
  end

  it_should_behave_like 'valid employee controllers'
end

describe 'Without a current_user method' do
  before(:each) do
    ApplicationController.tap do |app|
      app.send :alias_method, :old_current_user, :current_user
      app.send :remove_method, :current_user
      app.any_instance.stub(:authorize!)
    end
  end

  after(:each) do
    ApplicationController.tap do |app|
      app.send :alias_method, :current_user, :old_current_user
      app.any_instance.unstub(:authorize!)
    end
  end

  it_should_behave_like 'valid employee controllers'
end
