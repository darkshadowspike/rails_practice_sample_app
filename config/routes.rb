Rails.application.routes.draw do
 root 'static_pages#home'
 #get 'static_pages/help => root_url'
  get '/help', to: 'static_pages#help'
  #=> root_path'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/signup', to: 'users#new'
  post'/signup', to: 'users#create'

  get '/login', to: 'sessions#new'
  post'/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :account_activations, only: [:edit]
  resources :users
end

