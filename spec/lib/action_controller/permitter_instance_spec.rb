require 'spec_helper'

describe ActionController::Permitter, 'instance methods' do

  before { create_permitter('ExamplePermitter') }

  let(:params) do
    ActionController::Parameters.new({ example: { 'a' => 1, 'b' => 2} })
  end
  let(:permitter) { ExamplePermitter.new(params, nil) }

  describe '#authorize!' do

    let(:user) { double(:user) }
    before { allow(user).to receive :role }

    it 'uses Ability if there is no authorizer' do
      without_authorizer = ExamplePermitter.new(params, user)
      expect(Ability).to receive :new

      expect(without_authorizer.authorize!).to be_nil
    end

    it 'delegates to the authorizer class' do
      authorizer = double(:authorizer)
      expect(authorizer).to receive :authorize!

      ExamplePermitter.new(params, user, authorizer).authorize!
    end

  end

  describe '#permitted_params' do
    # for more rigorous integration tests of the permitters'
    # functionality, see spec/controllers/employees_controller_spec

    it 'disallows all parameters by default' do
      expect(permitter.permitted_params).to be_empty
    end

    it 'allows parameters which are explicitly permitted' do
      ExamplePermitter.permit :a

      expect(permitter.permitted_params).to eq({'a' => 1})
    end

  end

  describe '#resource_name' do

    it 'delegates to the class method' do
      expect(ExamplePermitter).to receive :resource_name

      permitter.resource_name
    end

  end

end