Rails.application.routes.draw do
  devise_for :users
  root 'products#index'

  resources :products, only: %i[index show] do
    resources :comments, only: %i[create]
  end

  resources :order_lines, only: %i[new create edit update destroy]

  resources :orders, only: %i[show destroy] do
    resources :comments, only: %i[create]
  end

  namespace :admin do
    resources :products, only: %i[new create edit update destroy]
    resources :change_logs, only: %i[index]
    resources :product_forms, only: %i[new create edit update]
  end

  namespace :customer do
    resources :orders, only: %i[index show create update]
    resources :likes, only: %i[create destroy]
    resources :order_lines
  end

  get 'shopping_cart', to: 'shopping_cart#index'
  get 'empty_cart' => 'shopping_cart#empty_cart'
  get 'checkout' => 'shopping_cart#checkout'
end
