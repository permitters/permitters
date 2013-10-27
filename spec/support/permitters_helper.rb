def create_permitter(class_name)
  if ActionController::const_defined?(class_name)
    Object.send :remove_const, class_name
  end

  Object.const_set(class_name, Class.new(ActionController::Permitter))
end