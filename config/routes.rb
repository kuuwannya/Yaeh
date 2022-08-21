Rails.application.routes.draw do
  mount RailsAdmin::Engine => '//admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'maps#search'
  get 'user_top', to: 'maps#user'
  get 'index', to: 'maps#index'
  resources :password_resets, only: %i[new create edit update]

  resources :spots
  resources :posts do
    resources :comments, shallow: true
  end
  resources :users do
    member do
      get 'withdrawal'
    end
  end
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  get 'terms', to: 'static_pages#terms'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  #post 'get_search_bike'
end
