Rails.application.routes.draw do
  get "/index", to: "static_pages#index", as: "guest_index"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users
end
