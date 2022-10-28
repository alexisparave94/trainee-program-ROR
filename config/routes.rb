Rails.application.routes.draw do
  devise_for :users
  root 'products#index'

  resources :products, only: %i[index show]
  get 'search/' => 'products#search_product'

  resources :order_lines, only: %i[new create edit update destroy]

  resources :carts, only: %i[show destroy]

  resources :orders, only: %i[show create destroy]
  get 'show_cart' => 'orders#show_cart'
  get 'checkout' => 'orders#checkout'

  namespace :admin do
    resources :products, only: %i[new create edit update destroy]
  end
end
