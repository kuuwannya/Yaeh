Rails.application.routes.draw do
  mount RailsAdmin::Engine => '//admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'maps#search'
  get 'user_top', to: 'maps#user'

  resources :spots
  resources :posts do
    resources :comments, shallow: true
  end
  resources :users
  resources :spots
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  post "guest_login", to: "user_sessions#guest_login"
  delete "logout", to: "user_sessions#destroy"
end
