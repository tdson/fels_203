Rails.application.routes.draw do
  namespace :admin do
    root "words#index"
    resources :categories
    resources :users, except: :update
    resources :words
  end

  root "static_pages#index"
  get "/index", to: "static_pages#index", as: "guest_index"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users, except: :delete
  resources :relationships, only: [:create, :destroy]
  resources :categories, only: :index do
    resources :lessons, except: [:index, :new, :destroy]
  end
end
