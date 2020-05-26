Rails.application.routes.draw do
  get 'users/new'
  root 'static_pages#index'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users
end
