[![Build Status](https://secure.travis-ci.org/permitters/permitters.png?branch=master)](http://travis-ci.org/permitters/permitters) [![Gem Version](https://badge.fury.io/rb/permitters.png)](http://badge.fury.io/rb/permitters)
# Permitters

Permitters are an object-oriented way of defining what request parameters are permitted using [Strong Parameters][strong_parameters]. It is to Strong Parameters what ActiveModel::Serializers are to as_json/to_json.

Permitters also allow additional parameter authorization using an authorizing class, such as CanCan's Ability class or a custom authorizer.

The original version of the Permitters framework that this was based on was provided in a [post][post] by Adam Hawkins.

### Installation

In your Rails app's `Gemfile`:

```ruby
gem 'permitters', '~> 0.0.1'
```

Then:

```
bundle install
```

#### Strong Parameters

If you are using Rails 4.x, Strong Parameters is included and everything should be setup, so you can skip this section.

If you are using Rails 3.x, you'll need [Strong Parameters][strong_parameters]:

```ruby
gem 'strong_parameters'
```

Also in Rails 3.x, you probably will want to change this to false in config:

```ruby
config.active_record.whitelist_attributes = false
```

and either put this in each model you want to use Strong Parameters with:

```ruby
include ActiveModel::ForbiddenAttributesProtection
```

Or if you'd rather use Strong Parameters with all models, just put this at the bottom of your `config/environment.rb` or an initializer:

```ruby
ActiveRecord::Base.send :include, ActiveModel::ForbiddenAttributesProtection
```

### Usage

First, either put this in each controller you want to use Strong Parameters with:

```ruby
include ActionController::Permittance
```

Or if you'd rather use Permitters with all controllers, just put this at the bottom of your `config/environment.rb` or an initializer:

```ruby
ActionController::Base.send :include, ActionController::Permittance
```

Then in your controller:

```ruby
def create
  @deal = Deal.new permitted_params
  # ...
end
```

Next, add a permitter for each controller that uses `ActionController::Permittance` in `/app/permitters/`.

For `/app/controllers/deals_controller.rb`, you would add a `/app/permitters/deal_permitter.rb`:

```ruby
class DealPermitter < ActionController::Permitter
  # No premissions required to set this
  permit :name, :description, :close_by, :state

  # can pass `:authorize` with a permission:
  # This line allows user_id if the user can read the user specified
  # by the user_id. This only happens if it's present
  permit :user_id, :authorize => :read

  # same thing but automatically handles arrays of ids as well.
  # This line allows the attachment_ids if the user can manage all
  # the specified attachments
  permit :attachment_ids, :authorize => :manage

  # same thing as before but scopes this it to the
  # hash inside the line_items_attributes array
  #
  # line_items_attributes is permitted if every item in the array
  # is allowed.
  # 
  # This also only allows line items if the user can manage the parent
  scope :line_items_attributes, :manage => true do |line_item|
    # So you cannot manipulate line items outside the parent
    line_item.permit :id, :authorize => :manage 

    line_item.permit :name, :quantity, :price, :currency, :notes
    line_item.permit :product_id, :authorize => :read
  end
end
```

When you call `permitted_params`, this happens:

```ruby
params.require(:deal).permit(:name, :description, :close_by, :state, :line_items_attributes => [:id, :name, :quantity, :price, :currency, :notes, product_id])
```

If the controller is namespaced, the permitter should have the same namespace, e.g. `A:B:DealsController` defined in `app/controllers/a/b/deals_controller.rb` requires `A:B:DealPermitter` defined in  `/app/a/b/permitters/deal_permitter.rb`.

If you need to override the argument(s) to pass into the require, use `resource` in the permitter:

```ruby
class DealPermitter < ActionController::Permitter
  resource :deal
  # ...
end
```

To specify a different Permitter to use with a Controller, either provide a `permitter_class` method:

```ruby
def permitter_class
  PersonPermitter
end
```

Or to specify the permitter, use `permitted_params_using(PermitterClass)`, e.g.:

```ruby
def make_cotton_candy
  @cotton_candy = CottonCandy.new(permitted_params_using(A::B::CottonCandyPermitter))
  # ...
end
```

### Authorizers

Permitters also allow additional parameter authorization using CanCan or a custom authorizer.

The authorizer class must implement `initialize(user)` and `authorize!(permission, record)` (like CanCan's Ability class).

The controller class can implement a method to return an instance of the authorizer class.

So, now let's add the `authorize!`:

```ruby
def create
  authorize! :create, Deal
  @deal = Deal.new permitted_params
  # ...
end
```

When you call `authorize!(:some_permission, YourModelClass)` method, that method will raise an error if `current_user` doesn't have the appropriate permissions for those attributes for which `:authorize` is specified.

#### Adding a Custom Authorizer

To set this up, you'll need to add one of these into your app config:

```ruby
config.action_controller.authorizer = 'SomeAuthorizer'
```

or:

```ruby
config.action_controller.current_authorizer_method = 'current_authorizer'
```

If neither is specified, then if the controller calls `authorize!(permission, record)`, nothing happens.

##### Without a Controller Method

Put this into your app config:

```ruby
config.action_controller.authorizer = 'SomeAuthorizer'
```

Create a class `lib/some_authorizer.rb` that has an `initialize(user)` and `authorize!(permission, record)` methods:

```ruby
class SomeAuthorizer

  def initialize(user)
    @user = user
  end

  def authorize!(permission, record)
    raise "You must login to create deals" if permission == :create && record == Deal && @user.name == 'guest'
  end
end
```

##### With a Controller Method

Put this into your app config:

```ruby
config.action_controller.current_authorizer_method = 'current_authorizer'
```

and in your controller or ApplicationController return an instance of an authorizer from that method:

```ruby
def current_authorizer
  @current_ability ||= ::SomeAuthorizer.new
end
```

Create a class `lib/some_authorizer.rb` that raises an error from `authorize!(permission, record)` if unauthorized:

```ruby
class SomeAuthorizer
  def authorize!(permission, record)
    raise "Deals can only be created from 8-5pm" if permission == :create && record == Deal && (Time.new.hour < 8 || Time.new.hour >= 17)
  end
end
```

##### CanCan

[CanCan][cancan] is able to integrate with the Permitters framework as an authorizer. To use CanCan, put this into your app config:

```ruby
config.action_controller.authorizer = 'Ability'
config.action_controller.current_authorizer_method = 'current_ability'
```

(Note: You could just define either. If you don't set current_authorizer_method, it will just try creating an instance of the authorizer using the current user. If neither are specified, nothing will happen when `authorize!(permission, record)` is called.)

CanCan can integrate with [Authlogic][authlogic], [Devise][devise], etc. to return a proper logged-in user, or you can return it however you wish from the `current_user` method in your controller. Just to provide a simple example, we'll pretend the user was logged-in and return a new User instance (which means you will need a User model):

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    User.new
  end
end
```

Again for simplicity, we'll write an "allow-everything" Ability in `app/models/ability.rb`:

```ruby
class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all
  end
end
```

Then in each model you want to use CanCan with, add this into the class:

```ruby
include CanCan::ModelAdditions
```

If you'd rather use CanCan with all models, just put this at the bottom of your `config/environment.rb` or an initializer:

```ruby
ActiveRecord::Base.send :include, CanCan::ModelAdditions
```

### Release Notes

See the [changelog][changelog].

### Contributors

* Adam Hawkins (https://github.com/twinturbo)
* Gary Weaver (https://github.com/garysweaver)

### License

Copyright (c) 2013 Adam Hawkins and Gary S. Weaver, released under the [MIT license][lic].

[post]: http://broadcastingadam.com/2012/07/parameter_authorization_in_rails_apis/
[cancan]: https://github.com/ryanb/cancan
[strong_parameters]: https://github.com/rails/strong_parameters
[authlogic]: https://github.com/binarylogic/authlogic
[devise]: https://github.com/plataformatec/devise
[changelog]: https://github.com/permitters/permitters/blob/master/CHANGELOG.md
[lic]: http://github.com/permitters/permitters/blob/master/LICENSE
