Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  root 'static_pages#index'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      get :followings
      get :followers
    end
  end
  
  resources :posts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
