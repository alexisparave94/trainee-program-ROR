Rails.application.routes.draw do
  resources :apidocs, only: [:index]
  get '/api' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')

  devise_for :users
  root 'products#index'

  resources :products, only: %i[index show]

  resources :order_lines, only: %i[new create edit update destroy]

  resources :orders, only: %i[show destroy]

  namespace :admin do
    resources :products, only: %i[destroy] do
      post "add_tag", on: :member
    end
    resources :change_logs, only: %i[index]
    resources :product_forms, only: %i[new create edit update]
    resources :comments, only: %i[destroy]
    patch 'comments/approve' => 'comments#approve'
    resources :transactions, only: %i[index]
  end

  namespace :customer do
    resources :orders, only: %i[index show update destroy]
    resources :likes, only: %i[create destroy]
    resources :order_lines, only: %i[destroy]
    resources :order_line_forms, only: %i[new create edit update]
    resources :comment_products, only: %i[create]
    resources :comment_orders, only: %i[create]
    get 'empty_cart' => 'shopping_cart#empty_cart'
    get 'checkout' => 'shopping_cart#checkout'
    resources :transactions, only: %i[index]
  end

  get 'shopping_cart', to: 'shopping_cart#index'
  get 'empty_cart' => 'shopping_cart#empty_cart'
  get 'checkout' => 'shopping_cart#checkout'

  resources :order_line_forms, only: %i[new create edit update]

  # Api routes
  namespace :api do
    namespace :v1 do
      post '/sign_in' => 'sessions#sign_in'
      resources :products, only: %i[index show]
      # namespace :customer do
        resources :likes, only: %i[create destroy]
        resources :order_lines, only: %i[create]
        resources :orders, only: %i[index]
        resources :comment_users, only: %i[create]
        get 'checkout' => 'orders#checkout'
      # end
      namespace :admin do
        resources :products, only: %i[index show create update destroy] do 
          patch 'discard', on: :member
          patch 'restore', on: :member
        end
        resources :comments, only: %i[destroy]
        patch 'comments/approve/:id' => 'comments#approve'
        resources :users, only: %i[create]
        patch 'users/soft_delete/:id' => 'users#discard', as: :user_soft_delete
        patch 'users/restore/:id' => 'users#restore', as: :user_restore
        # patch 'products/soft_delete/:id' => 'products#discard', as: :product_soft_delete
        # patch 'products/restore/:id' => 'products#restore', as: :product_restore
      end
    end
  end

  get 'forgot_password' => 'password#forgot_password'
  post 'reset_password' => 'password#reset_password'

  post 'checkout_pay' => 'checkout_pay#create'
  resources :webhooks, only: %i[create]
  post 'webhooks/checkout_session_completed' => 'webhooks#checkout_session_completed'
  post 'webhooks/payment_failed' => 'webhooks#payment_failed'
end
