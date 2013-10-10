# note: Rails 3.2.13 tested/works with SP 0.1.3 and up (through 0.2.x)
# note: Rails 3.1.12 tested/works with SP 0.1.5 and up (through 0.2.x)

[4.0, 3.2, 3.1].each do |version|
  appraise "rails_#{version}" do
    gem 'rails', "~> #{version}"
    gem 'strong_parameters' if version < 4
  end
end
