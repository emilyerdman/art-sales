Rails.application.routes.draw do
  get 'works', to: 'works#all'
  
  resources :pieces do
    resources :listings
  end

  resources :works

  resources :buyers

  resources :artists

  root 'works#all'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
