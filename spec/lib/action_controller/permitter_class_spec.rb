require 'spec_helper'

describe ActionController::Permitter, 'class methods' do

  before { create_permitter('ExamplePermitter') }
  let(:permitted_attributes) { ExamplePermitter.permitted_attributes }

  it 'initially has no permitted attributes' do
    expect(permitted_attributes).to be_empty
  end

  it 'infers the name of its resource from the name of the class' do
    expect(ExamplePermitter.resource_name).to eq :example
  end

  describe '.permit' do

    context 'with single attribute' do
      before { ExamplePermitter.permit :allowed }

      it 'adds a permitted attribute' do
        expect(permitted_attributes).to have(1).item
      end

      it 'stores the name of the permitted attribute' do
        expect(permitted_attributes.last.name).to eq :allowed
      end
    end

    context 'with multiple attributes' do
      before { ExamplePermitter.permit :allowed, :another, :etc }

      it 'adds all the permitted attributes' do
        expect(permitted_attributes).to have(3).items
      end

      it 'stores the name of the permitted attribute' do
        attribute_names = permitted_attributes.map(&:name)
        expect(attribute_names).to eq [:allowed, :another, :etc]
      end
    end

    context 'with options' do
      let(:opts) { { :message => 'Hello' } }

      it 'set on a single attribute' do
        ExamplePermitter.permit :allowed, opts

        expect(permitted_attributes.last.options).to eq opts
      end

      it 'set on multiple attributes' do
        ExamplePermitter.permit :allowed, :another, :etc, opts

        all_options_set = permitted_attributes.all? do |attribute|
          attribute.options == opts
        end

        expect(all_options_set).to be_true
      end
    end
  end

  describe '.resource' do

    it 'overrides the resource name' do
      ExamplePermitter.resource(:other)
      expect(ExamplePermitter.resource_name).to eq :other
    end

  end

  describe '.scope' do

    before do
      ExamplePermitter.class_eval do
        scope :my_scope do |scope|
          scope.permit :allowed
        end
      end
    end

    it 'sets the scope option on permitted attributes' do
      expect(permitted_attributes.last.options).to include({ :scope => :my_scope })
    end

  end

end