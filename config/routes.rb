Rails.application.routes.draw do
  resources :apidocs, only: [:index]
  # get '/api' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')
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
    get 'approve_comment' => 'comments#approve_comment'
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
        resources :likes, only: %i[create]
        resources :order_lines, only: %i[create]
        resources :orders, only: %i[index]
        get 'checkout' => 'orders#checkout'
      # end
      namespace :admin do
        resources :products, only: %i[show create update destroy]
      end
    end
  end
end
