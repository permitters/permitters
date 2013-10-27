require 'spec_helper'

class ExamplesController < ActionController::Base
  include ActionController::Permittance
end

class ExamplePermitter
  def initialize(*args); end
end

describe ExamplesController do

  let(:controller) { ExamplesController.new }
  before do
    controller.stub(params: {})
  end

  describe '#permitter_class' do

    it 'picks the permitter based on the class name' do
      expect(controller.permitter_class).to eq ExamplePermitter
    end

  end

  describe '#permitter' do

    it 'returns an instance of the appropriate permitter' do
      expect(controller.permitter).to be_an_instance_of ExamplePermitter
    end

    it 'caches the permitter' do
      a = controller.permitter
      b = controller.permitter
      expect(a.object_id).to eq b.object_id
    end

  end

  describe '#permitted_params' do

    it 'delegates to the default permitter class' do
      expect_any_instance_of(ExamplePermitter).to receive :permitted_params

      controller.permitted_params
    end

  end

  describe '#permitted_params_using' do

    it 'delegates to the specified permitter class' do
      OtherPermitter = ExamplePermitter.dup
      expect_any_instance_of(OtherPermitter).to receive :permitted_params

      controller.permitted_params_using(OtherPermitter)
    end

  end

end