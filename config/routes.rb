Rails.application.routes.draw do

  root    to: 'static_pages#home'
  get    'signup',  to: 'users#new'
  get    'users/:id/following' => 'users#followings', as: 'show_followings_user'
  get    'users/:id/followed' => 'users#followers', as: 'show_followers_user'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts
  resources :relationships, only: [:create, :destroy]

  devise_for :users, only: [:omniauth_callbacks], controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  
end
