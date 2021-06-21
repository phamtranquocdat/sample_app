Rails.application.routes.draw do
  get "/login", to:"sessions#new"
  post "/login", to:"sessions#create"
  delete "/logout", to:"sessions#destroy"
  get "static_pages/home"
  get "static_pages/help"
  root "static_pages#home"
  get "static_pages/about"
  get "static_pages/contact"
  get "/sign_up", to:"users#new"
  resources :users
end
