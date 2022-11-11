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
    resources :products, only: %i[new create edit update destroy] do
      post "add_tag", on: :member
    end
    resources :change_logs, only: %i[index]
    resources :product_forms, only: %i[new create edit update]
    resources :comments, only: %i[destroy]
    get 'approve_comment' => 'comments#approve_comment'
  end

  namespace :customer do
    resources :orders, only: %i[index show create update]
    resources :likes, only: %i[create destroy]
    resources :order_lines
    resources :order_line_forms, only: %i[new create edit update]
    get 'empty_cart' => 'shopping_cart#empty_cart'
    get 'checkout' => 'shopping_cart#checkout'
  end

  get 'shopping_cart', to: 'shopping_cart#index'
  get 'empty_cart' => 'shopping_cart#empty_cart'
  get 'checkout' => 'shopping_cart#checkout'

  resources :order_line_forms, only: %i[new create edit update]
end
