Rails.application.routes.draw do
  root 'products#index'

  resources :products
  get 'search/' => 'products#search_product'

  resources :order_lines, only: %i[new create edit update destroy]

  resources :carts, only: %i[show]
end
