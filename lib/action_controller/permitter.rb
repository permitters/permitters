module ActionController
  class PermitterAttribute < Struct.new(:name, :options); end
  class PermitterError < StandardError #:nodoc:
  end 
  class Permitter

    # Application-wide configuration
    cattr_accessor :authorizer, :instance_accessor => false
    cattr_accessor :current_authorizer_method, :instance_accessor => false

    class << self
      # When Permitter is inherited, it sets the resource (the symbol for params.require(some_sym)) to the unnamespaced model class that corresponds
      # to the Permitter's classname, e.g. by default A::B::ApplesController will use A::B::ApplePermitter which will do params.permit(:apple).
      # To change this value, use the `resource` class method.
      def inherited(subclass)
        subclass.class_eval do
          class_attribute :permitted_attributes, :resource_name_override
          private_class_method :resource_name_override, :resource_name_override=

          self.permitted_attributes = []
        end
      end

      def permit(*args)
        options = args.extract_options!

        args.each do |name|
          self.permitted_attributes += [ActionController::PermitterAttribute.new(name, options)]
        end
      end

      def scope(name)
        with_options :scope => name do |nested|
          yield nested
        end
      end

      def resource(name)
        self.resource_name_override = name
      end

      def resource_name
        name = self.name

        # in Rails 3.2+ could do:
        # name.demodulize.chomp('Permitter').underscore.to_sym
        # Rails < 3.2
        last_index = name.rindex('::')
        resource_name_override || (last_index ? name[(last_index+2)..-1] : name).chomp('Permitter').underscore.to_sym
      end
    end

    def initialize(params, user, authorizer = nil)
      @params, @user, @authorizer = params, user, authorizer
    end

    def permitted_params
      scopes = {}
      unscoped_attributes = []
      nil_attributes = []

      permitted_attributes.each do |attribute|
        scope_name = attribute.options[:scope]
        (scope_name ? (scopes[scope_name] ||= []) : unscoped_attributes) << attribute.name
      end

      # class_attribute creates an instance method called resource_name, which we'll allow overriding of in the permitter definition, if desired for some odd reason.
      @filtered_params ||= params.require(resource_name).permit(*unscoped_attributes, scopes)

      permitted_attributes.select {|a| a.options[:authorize]}.each do |attribute|
        scope_name = attribute.options[:scope]
        values = scope_name ? Array.wrap(@filtered_params[scope_name]).collect {|hash| hash[attribute.name]}.compact : Array.wrap(@filtered_params[attribute.name])
        klass_name = attribute.options[:as].try(:to_s) || attribute.name.to_s.split(/(.+)_ids?/)[1]
        raise PermitterError.new("Cannot permit #{attribute.name.inspect} unless you specify the the attribute name (e.g. :something_id or :something_ids), or a class name via the :as option (e.g. :as => Something)") unless klass_name
        klass = klass_name.classify.constantize

        values.each do |record_id|
          dependency_type = attribute.options[:dependent]
          record = dependency_type == :nullify ? klass.find_by(id: record_id) : klass.find(record_id)
          unless record.nil?
            permission = attribute.options[:authorize].to_sym || :read
            authorize! permission, record
          else
            nil_attributes.push attribute.name
          end
        end
      end

      return @filtered_params, nil_attributes
    end

    def authorize!(*args, &block)
      # implementing here is clearer than doing a delegate :authorize!, :to => :authorizer, imo.
      authorizer ? authorizer.__send__(:authorize!, *args, &block) : nil
    end

    def resource_name
      self.class.resource_name
    end

  private

    def params
      @params
    end

    def user
      @user
    end

    def authorizer
      # e.g. if ActionController::Permitter.authorizer = Ability
      # then this returns Ability.new(user)
      @authorizer ||= (ActionController::Permitter.authorizer.is_a?(String) ? ActionController::Permitter.authorizer.constantize : ActionController::Permitter.authorizer).try(:new, user)
    end
  end
end
