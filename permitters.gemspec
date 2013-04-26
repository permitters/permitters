# -*- encoding: utf-8 -*-  
$:.push File.expand_path("../lib", __FILE__)  
require "permitters/version" 

Gem::Specification.new do |s|
  s.name        = 'permitters'
  s.version     = Permitters::VERSION
  s.authors     = ['Adam Hawkins', 'Gary S. Weaver']
  s.email       = ['me@broadcastingadam.com', 'garysweaver@gmail.com']
  s.homepage    = 'https://github.com/permitters/permitters'
  s.summary     = %q{Object-oriented parameter authorization with Strong Parameters}
  s.description = %q{Permitters are an object-oriented way of defining what request parameters are permitted. using Strong Parameters. It is to Strong Parameters what ActiveModel::Serializers are to as_json/to_json, but supports CanCan and similar authorization frameworks.}
  s.files = Dir['lib/**/*'] + ['Rakefile', 'README.md']
  s.license = 'MIT'
  # NO! this is part of Rails 4 and Rails 4.0.0.beta1 will barf with "no superclass method `sanitize_for_mass_assignment'" errors if 2.0.0 included
  #s.add_runtime_dependency 'strong_parameters', '>= 0.1.3'
end
