Rails.application.routes.draw do
  get "/index", to: "static_pages#index", as: "guest_index"
end
