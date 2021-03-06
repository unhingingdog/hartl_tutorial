Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'account_activations/edit'

  root                            'static_pages#home'
  get  'about'       =>  'static_pages#about'
  get  'contact'    =>  'static_pages#contact'
  get  'help'          =>  'static_pages#help'
  get  'signup'      =>  'users#new'
  get 'login'          =>  'sessions#new'
  post 'login'        =>  'sessions#create'
  delete 'logout' =>  'sessions#destroy'
  resources :users
  resources :account_activations , only: [:edit]
  resources :password_resets,        only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
end
