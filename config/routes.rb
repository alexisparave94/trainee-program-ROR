Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'products#index'

  resources :products
  get 'search/' => 'products#search_product'

  resources :order_lines, only: %i[new create]

  resources :carts, only: %i[show]
end
