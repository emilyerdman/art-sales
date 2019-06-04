Rails.application.routes.draw do
  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  resources :users
  get 'works', to: 'works#all'
  
  resources :pieces do
    resources :listings
  end

  resources :works

  resources :buyers

  resources :artists

  root 'works#all'

  resources :sessions, only: [:new, :create, :destroy]

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  get 'approve_user/:id', to: 'users#approve', as: 'approve_user'
  get 'disapprove_user/:id', to: 'users#disapprove', as: 'disapprove_user'
  patch 'change_user_category/:id', to: 'users#change_user_category', as: 'change_user_category'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
