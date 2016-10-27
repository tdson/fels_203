Rails.application.routes.draw do
  namespace :admin do
    root "words#index"
    resources :categories, except: :update
    resources :words, only: :index
    resources :users, only: :index
  end

  root "static_pages#index"
  get "/index", to: "static_pages#index", as: "guest_index"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users
  resources :categories, only: :index do
    resources :lessons, except: [:index, :new, :destroy]
  end
end
