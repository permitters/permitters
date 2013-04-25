module ActionController
  module Permittance
    extend ActiveSupport::Concern

    def permitted_params
      get_permitted_params_using(permitter)
    end

    def permitted_params_using(pclass)
      get_permitted_params_using(permitter(pclass))
    end

    # Returns a new instance of the permitter by initializing it with params, current_user, current_ability.
    def permitter(pclass = permitter_class)
      pinstance = (@permitter_class_to_permitter ||= {})[pclass]
      return pinstance if pinstance
      current_authorizer_method = ActionController::Permitter.current_authorizer_method ? ActionController::Permitter.current_authorizer_method.to_sym : nil
      @permitter_class_to_permitter[pclass] = pclass.new(params, current_user, current_authorizer_method && defined?(current_authorizer_method) ? __send__(current_authorizer_method) : nil)
    end

    # Returns the permitter class corresponding to the controller by matching everything in the controller class name
    # other than "Controller" and singularizing the part after any namespace before tacking on Permitter to the name.
    #
    # e.g. if self.class.name is "A:B:StatusesController", it would return A::B::StatusPermitter
    def permitter_class
      # Permitters should be in the same namespace as the controller, like ActiveModel::Serializers are in the same namespace as the model.
      name = self.class.name
      # in Rails 3.2+ could do:
      # namespace = name.deconstantize; "#{namespace}#{namespace.blank? ? '' : '::'}#{name.demodulize.chomp('Controller').singularize}Permitter".constantize
      # Rails < 3.2
      last_index = name.rindex('::')
      "#{last_index ? "#{name[0...(last_index || 0)]}::" : ''}#{(last_index ? name[(last_index+2)..-1] : name).chomp('Controller').singularize}Permitter".constantize
    end

    private

    def get_permitted_params_using(pinstance)
      (@permitter_to_permitted_params ||= {})[pinstance] ||= pinstance.permitted_params
    end
  end
end
