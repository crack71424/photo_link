Rails.application.routes.draw do
  root to: 'static_pages#index'
  get 'static_pages/index'
  
end
