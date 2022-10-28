Rails.application.routes.draw do
  devise_for :users
  root 'products#index'

  resources :products, only: %i[index show] do
    resources :order_lines, only: %i[new create]
  end

  get 'search/' => 'products#search_product'

  resources :order_lines, only: %i[new create edit update destroy]

  resources :carts, only: %i[show destroy]

  resources :orders, only: %i[show destroy]
  get 'show_cart' => 'orders#show_cart'
  get 'checkout' => 'orders#checkout'

  namespace :admin do
    resources :products, only: %i[new create edit update destroy]
  end

  namespace :customer do
    resources :orders, only: %i[create destroy]
  end
end
