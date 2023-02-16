Rails.application.routes.draw do
  get 'relationships/followings'
  get 'relationships/followers'

  get 'articles/new'
  get 'sessions/new'
  get 'users/new'

  # それぞれのコントローラーの検索用アクションを用意
  get 'users_search' => 'users#search'
  get 'articles_search' => 'top#search'
  get 'user_articles_search' => 'articles#search'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'top#index'
  get '/signup', to: 'users#new'

  resources :users do
    # resources :articlesには、member doの記載は不要
    resources :articles do
      resources :comments, only: [:create, :destroy]
    end
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :relationships, only: [:index]

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post   '/guest_login', to: 'sessions#guest_create'

  # メソッドなので、articleではなくpost、delete
  post 'like/:id' => 'likes#create', as: 'create_like'
  delete 'like/:id' => 'likes#destroy', as: 'destroy_like'
end
