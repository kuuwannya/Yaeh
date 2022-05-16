Rails.application.routes.draw do
  mount RailsAdmin::Engine => '//admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "top#index"
  get "user_top", to: "top#user"
  resources :users
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  post "guest_login", to: "user_sessions#guest_login"
  delete "logout", to: "user_sessions#destroy"
  resources :users
  resources :spots
end
