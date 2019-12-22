Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'welcome#home'

  resources :merchants
  resources :items, except: [:new, :create]

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post "/cart/:item_id", to: "cart#add_item"
  patch "/cart", to: "cart#increment_decrement"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  resources :orders, only: [:new, :create, :show]
  get '/profile/orders', to: 'orders#index'
  get '/profile/orders/:id', to: 'orders#show'
  patch '/profile/orders/:id', to: 'order_status#update'

  get '/register', to: 'users#new'
  post '/register', to: "users#create"

  get '/user/edit-pw', to: 'user_password#edit'
  patch '/user/edit-pw', to: 'user_password#update'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/profile', to: "sessions#show"

  get "/users/:id/edit", to: "users#edit"
  patch "/users/:id/edit", to: "users#update"

  namespace :admin do
    get '/dashboard', to: 'dashboard#index'
    get '/merchants/:merchant_id', to: 'merchants#show'
    get '/users', to: 'users#index'
    get '/users/:id', to: 'users#show'
  end

  namespace :merchant do
    get '/dashboard', to: 'dashboard#index'
    get '/orders/', to: 'orders#index'
    get '/orders/:id', to: 'orders#show'
    get '/items', to: 'items#index' 
  end

  unless Rails.application.config.consider_all_requests_local
    get '*path', to: 'errors#error_404', via: :all
  end

  Rails.application.routes.draw do
    match '*path' => 'errors#error_404', via: :all
  end
end
