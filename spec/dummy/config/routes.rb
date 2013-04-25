Dummy::Application.routes.draw do
  resources :employees
  namespace :admin do
    resources :employees
    namespace :human_resources do
      resources :employees
    end
  end
end
