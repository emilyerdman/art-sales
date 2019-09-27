Rails.application.routes.draw do
  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  resources :users
  get 'works', to: 'works#all'

  resources :works do
    resources :apps
  end

  resources :artists


  root 'works#all'

  resources :sessions, only: [:new, :create, :destroy]

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  get 'approve_user/:id', to: 'users#approve', as: 'approve_user'
  get 'disapprove_user/:id', to: 'users#disapprove', as: 'disapprove_user'
  patch 'change_user_category/:id', to: 'users#change_user_category', as: 'change_user_category'

  get 'approve_app/:id', to: 'apps#approve', as: 'approve_app'
  get 'disapprove_app/:id', to: 'apps#disapprove', as: 'disapprove_app'
  get 'apps/admin', to: 'apps#admin_index', as: 'apps_admin'
  get 'apps', to: 'apps#index', as: 'user_apps'

  # works admin paths
  get 'works_admin', to: 'works#admin_index', as: 'works_admin'

  get 'password/forgot', to: 'passwords#show_reset', as: 'show_password_reset'
  post 'password/forgot', to: 'passwords#forgot', as: 'forgot_password'
  post 'password/reset', to: 'passwords#reset', as: 'reset_password'
  get 'password/reset', to: 'passwords#edit', as: 'edit_password'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
