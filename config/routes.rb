EmailAdministrator::Application.routes.draw do
  devise_for :emails
  
  resources :domains
  resources :password_resets
  resources :reset_passwords
  resources :emails do
    collection do
         get 'search'
     end
  end
  
  root :to => 'emails#index'
end
