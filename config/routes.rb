Rails.application.routes.draw do
  devise_for :users
  root 'products#index'

  resources :products, only: %i[index show] do
    resources :order_lines, only: %i[new create]
  end

  resources :order_lines, only: %i[new create edit update destroy]
  get 'empty_cart' => 'orders#empty_cart'

  resources :carts, only: %i[show destroy]

  resources :orders, only: %i[show destroy]
  get 'checkout' => 'orders#checkout'

  namespace :admin do
    resources :products, only: %i[new create edit update destroy]
    resources :change_logs, only: %i[index]
  end

  namespace :customer do
    resources :orders, only: %i[update]
    resources :likes, only: %i[create destroy]
  end
end
