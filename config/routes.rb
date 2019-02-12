Rails.application.routes.draw do
  get 'home/index'
  get 'listings', to: 'listings#all'
  get 'buyers/newlisting', to: 'buyers#new_listing'
  get 'works', to: 'works#all'
  
  resources :pieces do
    resources :listings
  end

  resources :works

  resources :buyers

  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
