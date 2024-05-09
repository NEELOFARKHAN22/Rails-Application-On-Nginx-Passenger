Rails.application.routes.draw do
  get 'search',to: "search#index"
  
  resources :user
  resources :posts do 

    resources :comments

  end
  resources :invitations
  resources :likes , only: [:create,:destroy]
  
  patch "accept",to: "invitations#accept"


  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "posts#index"
end
