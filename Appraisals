appraise 'rails_4.0.0.beta1' do
  gem 'rails', '4.0.0.beta1'
  # includes its own strong parameters and get errors if we include it
end

#['0.1.3', '0.1.4', '0.1.5', '0.1.6', '0.2.0', 'edge'].each do |strong_parameters_version|
['0.1.6', '0.2.0', 'edge'].each do |strong_parameters_version|
  appraise "rails_3.2.13_with_strong_parameters_#{strong_parameters_version}" do
    gem 'rails', '3.2.13'
    if strong_parameters_version == 'edge'
      gem 'strong_parameters', :git => 'git://github.com/rails/strong_parameters.git'
    else
      gem 'strong_parameters', strong_parameters_version
    end
  end
end

#['0.1.5', '0.1.6', '0.2.0', 'edge'].each do |strong_parameters_version|
['0.1.6', '0.2.0', 'edge'].each do |strong_parameters_version|
  appraise "rails_3.1.12_with_strong_parameters_#{strong_parameters_version}" do
    gem 'rails', '3.1.12'
    if strong_parameters_version == 'edge'
      gem 'strong_parameters', :git => 'git://github.com/rails/strong_parameters.git'
    else
      gem 'strong_parameters', strong_parameters_version
    end
  end
end
