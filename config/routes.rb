Rails.application.routes.draw do

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
end
