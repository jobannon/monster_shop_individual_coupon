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
    get '/users', to: 'users#index'
    get '/merchants/:merchant_id', to: 'merchants#show'
    get '/users/:id', to: 'users#show'
    get '/:merchant_id/items', to: 'items#index'
    get '/users/:id/orders', to: 'orders#index'
    patch '/orders/:id', to: 'orders#update'
    get '/users/:id/orders/:id', to: 'orders#show'
    get '/merchants', to: 'merchants#index'
    patch '/merchants/:id', to: 'merchants#update'
    get '/merchant/:merchant_id/orders/:order_id', to: 'merchantorders#show'
    patch '/merchantorders/:item_order_id', to: 'merchantorders#update'
    get '/users/:id/edit', to: 'users#edit'
    get '/users/:id/edit-pw', to: 'user_password#edit'
    patch '/users/:id/edit-pw', to: 'user_password#update'
  end

  namespace :merchant do
    get '/dashboard', to: 'dashboard#index'
    get '/orders/', to: 'orders#index'
    patch '/orders/:item_order_id', to: 'orders#update'
    get '/orders/:id', to: 'orders#show'
    get '/items', to: 'items#index'
    patch '/items/:id', to: 'items#update'
  end

  Rails.application.routes.draw do
    match '*path' => 'errors#error_404', via: :all
  end
end
