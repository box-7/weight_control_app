Rails.application.routes.draw do
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
    # member do
    resources :articles
    # end
  end


  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
